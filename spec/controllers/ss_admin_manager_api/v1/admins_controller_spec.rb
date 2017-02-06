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
    expect { subject }.to change { admin.reload.last_name }.from(admin.last_name).to("Jones")
  end

  it "should update the admin email" do
    expect { subject }.to change { admin.reload.email }.from(admin.email).to(email)
  end
end

describe SsoAdminManagerApi::V1::AdminsController do
  before do
    controller.request.env["HTTP_AUTHORIZATION"] = authorization
  end

  routes { SsoAdminManagerApi::Engine.routes }

  let(:default_params) { { format: :json, authorization: authorization } }
  let(:authorization) { "Bearer #{ qa_token }" }
  let(:qa_token) { "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik1RdjVzaDZ6ZElvb3l2eHFER2M1c2dOVWdUUSIsImtpZCI6Ik1RdjVzaDZ6ZElvb3l2eHFER2M1c2dOVWdUUSJ9.eyJpc3MiOiJodHRwczovL2lkZW50aXR5LXFhMDUubmZnaHEub3JnIiwiYXVkIjoiaHR0cHM6Ly9pZGVudGl0eS1xYTA1Lm5mZ2hxLm9yZy9yZXNvdXJjZXMiLCJleHAiOjE2MzQ1OTgwNDksIm5iZiI6MTQ3NjgxMDA0OSwiY2xpZW50X2lkIjoiTmdmVDNzdGlEIiwiY2xpZW50X3BhcnRuZXJfaWQiOiIxMDA4NTMiLCJjbGllbnRfY2FwYWJpbGl0aWVzIjpbIjAiLCIxIiwiMiIsIjMiLCI0IiwiNiIsIjgiLCI5IiwiMTAiLCIxMSIsIjEyIiwiMTMiLCIxNCIsIjE1IiwiMTYiLCIxOCIsIjE5IiwiMjAiLCIyMSJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMTU2NCI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5Il0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzQwIjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMjc0MiI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5IiwiMTAiXSwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTI3MzgiOlsiMCIsIjEiLCI1IiwiNiIsIjciLCI4IiwiOSIsIjEwIl0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzM2IjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMjc0MyI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5IiwiMTAiXSwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTI3MzkiOlsiMCIsIjEiLCI1IiwiNiIsIjciLCI4IiwiOSIsIjEwIl0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzM3IjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMjc0MSI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5IiwiMTAiXSwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTI3MjMiOlsiMCIsIjEiLCI1IiwiNiIsIjciLCI4IiwiOSIsIjEwIl0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzM1IjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMDQ5MSI6WyIwIiwiMSIsIjQiLCI1IiwiNiIsIjciLCI4IiwiOSJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMTY2OSI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5Il0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczExNjUxIjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiXSwic2NvcGUiOlsiZG9uYXRpb24iLCJkb25hdGlvbi1yZXBvcnRpbmciLCJpZG1nciJdLCJqdGkiOiI3Y2NmNzBlOGZkNjY0NGE4ZGMxYWMwY2NiYzU4MDk0ZSJ9.i2fyyPJq_ko8HBJxChrH7upV4lDu1vAba6EToQvznoAaMwrJkoGdKp78LtyAxpKtZVItR8mEH97XcFmZxiTY9Vof3ShWFLtPjzzVyxM3pjNQuzzzEJTgA7Vm4-dGGue4cm4JMsqhuW6h_c8JAHISHnscjguTsx6wNldykLPAEFniUMLo_c_WF1GenRAM0xGiqjz3wmugJ7KFsrl4_8WW6-GzfEyMp5CRNjyeiUs9_aL5Z2qDfvIo0ewWf6Hr7Cz0CYZxHeWtbazx2nZU10UQuhi5LMwN-65NRrSAaQeuUlBZWVvrau5HYKcA5PbKEH_g4ME1Hy-WwZpahvTJQ7gpqA" }
  let(:serialized_result) { ActiveModelSerializers::SerializableResource.new(admin.reload,
                            serializer: SsoAdminManagerApi::V1::AdminSerializer).to_json }

  describe "#update" do
    let(:admin) { Admin.create(first_name: "Smith",
                                last_name: "Sam",
                                email: "this@that.com",
                                status: status,
                                roles: ["supervisor"]) }
    # let(:admin) { Admin.first }
    let(:email) { "jon@example.com" }
    let(:status) { "active" }
    let(:identifier) { admin.email }

    subject { post :update, { id: identifier }.merge(params) }

    context "with an invalid authorization token" do
      let(:qa_token) { "baz" }
      let(:params) { default_params.merge(email: email, last_name: "Jones") }

      it "should return a 500 error" do
        expect(subject).to have_http_status(500)
      end
    end

    context "when no id param is included" do
      let(:identifier) { nil }
      let(:params) { default_params.merge(email: email, last_name: "Jones") }

      it "should raise an error" do
        expect { subject }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'when an email is provided as an id' do
      let(:params) { default_params.merge(email: email, last_name: "Jones") }

      context 'and it does not match any admins email' do
        let(:identifier) { "bad@this.com" }

        it "should return of 404 error" do
          expect(subject).to have_http_status(404)
        end
      end

      context "and it matches one admin's email" do

        let(:identifier) { admin.email }

        it_should_behave_like "a valid admin that has been updated"

      end
    end
  end
end