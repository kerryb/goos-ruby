shared_examples_for "an auction event listener" do
  it "responds to #auction_closed" do
    expect(subject).to respond_to :auction_closed
  end

  it "responds to #current_price" do
    expect(subject).to respond_to :current_price
  end

  it "responds to #auction_failed" do
    expect(subject).to respond_to :auction_failed
  end
end

