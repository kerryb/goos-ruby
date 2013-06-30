shared_examples_for "a sniper listener" do
  it "responds to #sniper_state_changed" do
    expect(subject.respond_to? :sniper_state_changed).to be_true
  end
end
