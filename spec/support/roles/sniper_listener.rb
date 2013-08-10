shared_examples_for "a sniper listener" do
  it "responds to #sniper_state_changed" do
    expect(subject).to respond_to :sniper_state_changed
  end
end
