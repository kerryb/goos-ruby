require "item"

describe Item do
  subject { Item.new "item-123", 100 }

  it "allows bids below its stop price" do
    expect(subject.allows_bid? 99).to be_true
  end

  it "allows bids at its stop price" do
    expect(subject.allows_bid? 100).to be_true
  end

  it "does not allow bids above its stop price" do
    expect(subject.allows_bid? 101).to be_false
  end
end
