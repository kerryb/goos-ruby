shared_examples_for "an auction" do
  it "responds to #bid" do
    expect(subject.respond_to? :bid).to be_true
  end
end

