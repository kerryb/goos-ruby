shared_examples_for "an auction event listener" do
  it "responds to #auction_closed" do
    expect(subject.respond_to? :auction_closed).to be_true
  end

  it "responds to #current_price" do
    expect(subject.respond_to? :current_price).to be_true
  end
end

