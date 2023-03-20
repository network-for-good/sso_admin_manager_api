require 'rails_helper'

class AdminWithoutOrgID
  alias :read_attribute_for_serialization :send
  attr_accessor :id, :first_name, :last_name, :email, :status,
                :roles, :root_url, :org_status, :org_identifier, :app,
                :created_at, :updated_at, :product_names

  def initialize(params)
    params.each do |attr, value|
      instance_variable_set("@#{attr}", value)
    end
    %i[created_at updated_at].each do |attr|
      instance_variable_set("@#{attr}", Time.zone.now)
    end
  end

  def self.model_name
    @_model_name ||= ActiveModel::Name.new(self)
  end
end

class AdminWithOrgAndOrgID < AdminWithoutOrgID
  attr_accessor :org_id
end

class AdminWithOrg < AdminWithoutOrgID
  attr_accessor :org
end

RSpec.describe SsoAdminManagerApi::V1::AdminSerializer do
  let(:base_attributes) {
    {
      id: 1,
      first_name: 'John',
      last_name: 'Smith',
      email: 'john@smith.com',
      status: 'active',
      roles: ['supervisor'],
      root_url: 'https://my.example.com/admin/123',
      org_status: 'active',
      org_identifier: 'demo',
      app: 'evo',
      product_names: ['auction']
    }
  }

  let(:serializer) { described_class.new(admin) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  context 'when the model does not have an org_id attribute' do
    context 'and does not have an org attribute' do
      let(:admin) { AdminWithoutOrgID.new(attributes) }
      let(:attributes) { base_attributes }

      it 'properly creates a serialized hash' do
        expect(subject['email']).to eq(admin.email)
      end

      it 'returns nil for org_id' do
        expect(subject["org_id"]).to eq(nil)
      end
    end

    context "and it has an org attribute with an id" do
      let(:admin) { AdminWithOrg.new(attributes) }
      let(:attributes) { base_attributes.merge(org: OpenStruct.new(id: 164)) }

      it 'returns the orgs id for org_id' do
        expect(subject["org_id"]).to eq(164)
      end
    end

    context "and it has an org_id attribute" do
      let(:admin) { AdminWithOrgAndOrgID.new(attributes) }
      let(:attributes) { base_attributes.merge(org_id: 188) }

      it 'returns the orgs id for org_id' do
        expect(subject["org_id"]).to eq(188)
      end
    end
  end
end
