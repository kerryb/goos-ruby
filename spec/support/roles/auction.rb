shared_examples_for "an auction" do
  it "responds to #join" do
    expect(subject.respond_to? :join).to be_true
  end

  it "responds to #bid" do
    expect(subject.respond_to? :bid).to be_true
  end
end
