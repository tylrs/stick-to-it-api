RSpec.shared_examples "a protected route" do
  before do
    send(request_type, path, headers: {})
  end

  it "returns unauthorized status" do
    expect(response).to have_http_status(:unauthorized)
  end
end
