shared_examples_for "a sniper listener" do
  it "responds to #sniper_bidding" do
    expect(subject.respond_to? :sniper_bidding).to be_true
  end

  it "responds to #sniper_winning" do
    expect(subject.respond_to? :sniper_winning).to be_true
  end

  it "responds to #sniper_lost" do
    expect(subject.respond_to? :sniper_lost).to be_true
  end
end

