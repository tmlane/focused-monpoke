require_relative "../lib/game"
require_relative "../lib/team"
require_relative "../lib/monpoke"

describe Game do
  let!(:game) { described_class.new("Rocket", "Pikachu", "3", "4") } #initializes game before every describe block

  describe "#initialize" do
    it "creates a new game" do
      expect(game).to be_a(Game)
    end

    it "creates the first team and sets it to current team" do
      expect(game.current_team).to be_a(Team)
    end

    it "creates the first monpoke and assigns it to the first team" do
      expect(game.team_1.monpokes.first).to be_a(Monpoke)
    end
  end

  describe "#create" do
    let(:subject) { game.create(command) }
    let(:command) { ["Rocket", "Ivysore", "3", "4"] }

    context "when team-id matches team_1" do
      it "adds the monpoke to team_1" do
        expect { subject }.to change { game.team_1.monpokes.count }.from(1).to(2)
      end
      it "returns the correct output message" do
        expect(subject).to eq("Ivysore has been assigned to team Rocket!")
      end
    end

    context "when team-id matches team_2" do
      let!(:command) { ["Orange", "Ivysore", "3", "4"] }
      before do
        game.team_2 = Team.new("Orange")
      end
      it "adds the monpoke to team_2" do
        expect { subject }.to change { game.team_2.monpokes.count }.from(0).to(1)
      end
      it "returns the correct output message" do
        expect(subject).to eq("Ivysore has been assigned to team Orange!")
      end
    end

    context "when team-id does not match team_1 AND team_2 is nil" do
      let!(:command) { ["Green", "Ivysore", "3", "4"] }

      it "creates the new team and assigns it to team_2" do
        expect { subject }.to change { game.team_2 }.from(NilClass).to(Team)
      end

      it "adds the monpoke to team 2" do
        subject
        expect(game.team_2.monpokes.first.id).to eq("Ivysore")
      end
      it "returns the correct outputs message" do
        expect(subject).to eq("Ivysore has been assigned to team Green!")
      end
    end
  end

  describe "#pass_turn" do
    let(:subject) { game.pass_turn }
    before do
      game.team_2 = Team.new("Orange")
    end

    context "when current_team was team_1" do
      before do
        game.current_team = game.team_1
      end
      it "changes current team to team_2" do
        expect { subject }.to change { game.current_team }.from(game.team_1).to(game.team_2)
      end
    end
    context "when current_team was team_2" do
      before do
        game.current_team = game.team_2
      end
      it "changes current team to team_2" do
        expect { subject }.to change { game.current_team }.from(game.team_2).to(game.team_1)
      end
    end
  end
  describe "#play_turn" do
    let(:subject) { game.play_turn(command) }
    let(:command) { ["CREATE", "Rocket", "Rastly", "5", "6"] }

    before do
      allow(game).to receive(:create)
      allow(game).to receive(:attack)
    end

    context "when command is CREATE" do
      it "calls create method" do
        expect(game).to receive(:create)
        subject
      end
      it "does not pass the turn" do
        expect { subject }.not_to change { game.current_team }
      end
    end
    context "when command is ATTACK" do
      let!(:command) { ["ATTACK"] }

      it "calls attack method" do
        expect(game).to receive(:attack)
        subject
      end
      it "passes the turn" do
        expect { subject }.to change { game.current_team }
      end
    end
  end

  describe "#opposite_team" do
    let(:subject) { game.opposite_team }
    before do
      game.team_2 = Team.new("Orange")
    end

    context "when current_team is team_1" do
      before do
        game.current_team = game.team_1
      end
      it "returns team_2" do
        expect(subject).to eq(game.team_2)
      end
    end
    context "when current_team is team_2" do
      before do
        game.current_team = game.team_2
      end
      it "returns team_2" do
        expect(subject).to eq(game.team_1)
      end
    end
  end

  describe "#attack" do
    let(:subject) { game.attack() }

    context "when both teams are not ready for battle" do
      it "raises exit error 1" do
        expect { game.attack() }.to raise_error(SystemExit)
      end
    end
    context "when both teams are ready for battle" do
      let(:attacker) { Monpoke.new("Metapahd", "5", "3") }
      let(:defender) { Monpoke.new("Ivysore", "6", "4") }
      let(:defender_2) { Monpoke.new("Charzar", "7", "5") }
      let(:team_2) { Team.new("Orange") }
      before do
        team_2.monpokes = [defender, defender_2]
        game.current_team = game.team_1
        game.team_2 = team_2
        game.team_1.current_monpoke = attacker
        game.team_2.current_monpoke = defender
      end
      context "non-critical attack " do
        it "changes HP of defender by AP of attacker" do
          expect { subject }.to change { defender.hp }.from(6).to(3)
        end
        it "returns just the attack output" do
          expect(subject).to eq("Metapahd attacked Ivysore for 3 damage!")
        end
      end
      context "critical attack" do
        before do
          attacker.ap = 10
        end
        it "returns the attack and defeated output" do
          expect(subject).to eq("Metapahd attacked Ivysore for 10 damage!\nIvysore has been defeated!")
        end
        it "adds 1 to the graveyard" do
          expect { subject }.to change { team_2.graveyard }.from(0).to(1)
        end
        context "final kill" do
          before do
            allow(team_2).to receive(:defeated?).and_return(true)
          end
          it "returns the attack, defeated, and game winner output" do
            expect(subject).to eq("Metapahd attacked Ivysore for 10 damage!\nIvysore has been defeated!\nRocket is the winner!")
          end
          it "changes HP of defender by AP of attacker" do
            expect { subject }.to change { game.game_over }.from(false).to(true)
          end
        end
      end
    end
  end
end
