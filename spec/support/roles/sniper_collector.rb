shared_examples_for "a sniper collector" do
  it "responds to #add_sniper" do
    expect(subject.respond_to? :add_sniper).to be_true
  end
end
