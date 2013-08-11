shared_examples_for "a portfolio listener" do
  it "responds to #sniper_added" do
    expect(subject).to respond_to :sniper_added
  end
end
