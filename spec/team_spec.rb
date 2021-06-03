require_relative "../lib/team"
require_relative "../lib/monpoke"

describe Team do
  let!(:team) { described_class.new("Orange", [monpoke]) }
  let(:monpoke) { Monpoke.new("Ratatta", "4", "7") }
  describe "#initialize" do
    it "creates a new Team" do
      expect(team).to be_a(Team)
    end
    context "when ap or hp are less than 1" do
      let(:subject) { Monpoke.new("Katerpie", 0, 2) }
      it "raises an error" do
        expect { subject }.to raise_error(SystemExit, "Monpoke must start with at least 1 hp & ap")
      end
    end
  end
  describe "#defeated?" do
    let(:subject) { team.defeated? }
    context "when team is not defeated" do
      it "returns false" do
        expect(subject).to be(false)
      end
    end
    context "when team is defeated" do
      before do
        team.graveyard = 1
      end
      it "returns true" do
        expect(subject).to be(true)
      end
    end
  end
  describe "#choose" do
    let(:subject) { team.choose(monpoke_id) }
    let(:monpoke_id) { "Ratatta" }
    context "when monpoke exists on team" do
      it "sets monpoke to current_monpoke" do
        expect { subject }.to change { team.current_monpoke }.from(NilClass).to(monpoke)
      end
      it "returns entered battle output" do
        expect(subject).to eq("Ratatta has entered the battle!")
      end
    end
    context "when monpoke does not exist on team" do
      let!(:monpoke_id) { "Arbok" }
      it "raises error" do
        expect { subject }.to raise_error(SystemExit, "Monpoke not found")
      end
    end
  end
end
