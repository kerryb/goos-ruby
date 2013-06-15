shared_examples_for "a sniper listener" do
  it "responds to sniper_bidding/0" do
    expect(subject.method(:sniper_bidding).arity).to eq(0)
  end

  it "responds to sniper_lost/0" do
    expect(subject.method(:sniper_lost).arity).to eq(0)
  end
end

