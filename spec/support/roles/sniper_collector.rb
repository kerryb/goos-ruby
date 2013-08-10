shared_examples_for "a sniper collector" do
  it "responds to #add_sniper" do
    expect(subject).to respond_to :add_sniper
  end
end
