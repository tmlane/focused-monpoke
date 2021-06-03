require_relative "../lib/monpoke"
describe Monpoke do
  let!(:monpoke) { described_class.new("Katerpie", "5", "3") }

  describe "#initialize" do
    it "creates a new Monpoke" do
      expect(monpoke).to be_a(Monpoke)
      expect(monpoke.ap).to eq(3)
      expect(monpoke.hp).to eq(5)
    end
    context "when ap or hp are less than 1" do
      let(:subject) { Monpoke.new("Katerpie", 0, 2) }
      it "raises an error" do
        expect { subject }.to raise_error(SystemExit, "Monpoke must start with at least 1 hp & ap")
      end
    end
  end
  describe "#alive?" do
    let(:subject) { monpoke.alive? }

    it "returns true when monpoke is alive" do
      expect(subject).to be(true)
    end
    context "when monpoke is dead" do
      before do
        monpoke.hp = 0
      end
      it "returns false" do
        expect(subject).to be(false)
      end
    end
  end
end
