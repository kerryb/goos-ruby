shared_examples_for "an auction" do
  it "responds to #add_event_listener" do
    expect(subject.respond_to? :add_event_listener).to be_true
  end

  it "responds to #join" do
    expect(subject.respond_to? :join).to be_true
  end

  it "responds to #bid" do
    expect(subject.respond_to? :bid).to be_true
  end
end
