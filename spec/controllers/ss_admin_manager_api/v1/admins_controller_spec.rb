require "rails_helper"
# require "../../app/controllers/sso_admin_manager_api/v1/admins_controller.rb"

shared_examples_for "a valid admin that has been updated" do
  it "should return a 200 response" do
    expect(subject).to have_http_status(200)
  end

  it "should return the admin's attributes" do
    expect(subject.body).to eq(serialized_result)
  end

  it "should update the admin last name" do
    expect { subject }.to change { admin.reload.last_name }.from("Smith").to("Jones")
  end

  it "should update the admin email" do
    expect { subject }.to change { admin.reload.email }.from("this@that.com").to(email)
  end
end

shared_examples_for "a valid admin that has been found" do
  it "should return a 200 response" do
    expect(subject).to have_http_status(200)
  end

  it "should return the admin's attributes" do
    expect(subject.body).to eq(serialized_result)
  end
end


describe SsoAdminManagerApi::V1::AdminsController do
  before do
    controller.request.env["HTTP_AUTHORIZATION"] = authorization
  end

  routes { SsoAdminManagerApi::Engine.routes }

  let(:default_params) { { format: :json, authorization: authorization } }
  let(:authorization) { "Bearer #{ qa_token }" }
  let(:qa_token) { JWT.encode({ env: 'test' }, '', 'HS256') }

  describe "#update" do
    let!(:admin) { Admin.create(admin_params) }
    let(:email) { "jon@example.com" }
    let(:status) { "active" }
    let(:identifier) { admin.email }
    let(:sso_id) { nil }

    let(:admin_params) { { first_name: "Sam",
                            last_name: "Smith",
                            email: "this@that.com",
                            status: status,
                            roles: ["supervisor"],
                            sso_id: sso_id } }

    let(:serialized_result) { ActiveModelSerializers::SerializableResource.new(admin.reload,
                              serializer: SsoAdminManagerApi::V1::AdminSerializer, key_transform: :underscore, adapter: :json_api).to_json }


    subject { post :update, params: { id: identifier }.merge(params) }
    let(:params) { default_params.merge(email: email, last_name: "Jones") }

    context "with an invalid authorization token" do
      let(:qa_token) { "baz" }

      it "should return a 500 error" do
        expect(subject).to have_http_status(500)
      end
    end

    context "with an internal id that matches the id of a user" do
      let(:identifier) { admin.id }

      it_should_behave_like "a valid admin that has been updated"
    end

    context "with an internal id that does not match the id of a user" do
      let(:identifier) { 0 }

      it "should return of 404 error" do
        expect(subject).to have_http_status(404)
      end
    end
  end

  describe "#index" do
    let!(:admin) { Admin.create(admin_params) }
    let(:email) { "jon@example.com" }
    let(:status) { "active" }
    let(:query_param) { { email: admin.email } }
    let(:sso_id) { nil }

    let(:admin_params) { { first_name: "Sam",
                            last_name: "Smith",
                            email: "this@that.com",
                            status: status,
                            roles: ["supervisor"],
                            sso_id: sso_id } }

    let(:serialized_result) { ActiveModelSerializers::SerializableResource.new([admin.reload], each_serializer: SsoAdminManagerApi::V1::AdminSerializer, adapter: :json_api, key_transform: :underscore, meta: {record_count: 1}).to_json }


    subject { get :index, params: query_param.merge(default_params) }

    context "with an invalid authorization token" do
      let(:qa_token) { "baz" }

      it "should return a 500 error" do
        expect(subject).to have_http_status(500)
      end
    end

    context 'with no query param' do
      let(:query_param) { {} }

      it "should return of 404 error" do
        expect(subject).to have_http_status(404)
      end
    end

    context "when an invalid query param" do
      let(:query_param) { { baz: "bar" } }

      it "should return of 404 error" do
        expect(subject).to have_http_status(404)
      end
    end

    context 'when an email is provided as an id' do

      context 'and it does not match any admins email' do
        let(:query_param) { { email: "bad@this.com" } }

        it "should return of 404 error" do
          expect(subject).to have_http_status(404)
        end
      end

      context "and it matches one admin's email" do
        let(:query_param) { { email: admin.email } }

        it_should_behave_like "a valid admin that has been found"
      end

    end

    context "with an sso_id that matches the sso_id of a user" do
      let(:sso_id) { "__sso_id__" }
      let(:query_param) { { sso_id: sso_id } }

      it_should_behave_like "a valid admin that has been found"

    end

    context 'when an internal id' do
      context "that matches the id of a user" do
        let(:query_param) { { id: admin.id } }

        it_should_behave_like "a valid admin that has been found"
      end

      context "that does not match the id of a user" do
        let(:query_param) { { id: 0 } }

        it "should return of 404 error" do
          expect(subject).to have_http_status(404)
        end
      end
    end

    context "when the id matches multiple admins" do
      let!(:admin2) { Admin.create(admin_params) }
      let(:query_param) { { email: admin.email } }

      let(:serialized_result) { ActiveModelSerializers::SerializableResource.new([admin.reload, admin2.reload], each_serializer: SsoAdminManagerApi::V1::AdminSerializer, key_transform: :underscore, adapter: :json_api, meta: {record_count: 2}).to_json }

      it_should_behave_like "a valid admin that has been found"
    end
  end
end
