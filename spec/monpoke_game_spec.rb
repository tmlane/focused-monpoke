require_relative "../lib/monpoke_game"
include MonpokeGame

describe MonpokeGame do
  describe "#play" do
    let(:input) {
      ["CREATE Rocket Meekachu 3 1",
       "CREATE Rocket Rastly 5 6",
       "CREATE Green Smorelax 2 1",
       "ICHOOSEYOU Meekachu",
       "ICHOOSEYOU Smorelax",
       "ATTACK",
       "ATTACK",
       "ICHOOSEYOU Rastly",
       "ATTACK",
       "ATTACK"]
    }

    let(:expected_output) {
      ["Meekachu has been assigned to team Rocket!",
       "Rastly has been assigned to team Rocket!",
       "Smorelax has been assigned to team Green!",
       "Meekachu has entered the battle!",
       "Smorelax has entered the battle!",
       "Meekachu attacked Smorelax for 1 damage!",
       "Smorelax attacked Meekachu for 1 damage!",
       "Rastly has entered the battle!",
       "Smorelax attacked Rastly for 1 damage!",
       "Rastly attacked Smorelax for 6 damage!\nSmorelax has been defeated!\nRocket is the winner!"]
    }

    let(:game) { described_class.play(input) }
    it "returns the correct game output" do
      expect(game.play_log).to eq(expected_output)
    end
    it "does not raise error" do
      expect { subject.play(input) }.not_to raise_error(SystemExit)
    end
    context "when a team tries to create a monpoke after the first ICHOOSEYOU has been called" do
      let!(:input) {
        ["CREATE Rocket Meekachu 3 1",
         "CREATE Rocket Rastly 5 6",
         "CREATE Green Smorelax 2 1",
         "ICHOOSEYOU Meekachu",
         "CREATE Rocket Doggy 5 6"]
      }
      it "it raises error" do
        expect { subject.play(input) }.to raise_error(SystemExit)
      end
    end
    context "when team_1 tries to choose a monpoke before team_2 is created" do
      let!(:input) {
        ["CREATE Rocket Meekachu 3 1",
         "CREATE Rocket Rastly 5 6",
         "ICHOOSEYOU Meekachu"]
      }
      it "it raises error" do
        expect { subject.play(input) }.to raise_error(SystemExit)
      end
    end
    context "when team_1 tries to choose a monpoke before team_2 is created" do
      let!(:input) {
        ["ICHOOSEYOU",
         "CREATE Rocket Rastly 5 6",
         "ICHOOSEYOU Meekachu"]
      }
      it "it raises error" do
        expect { subject.play(input) }.to raise_error(SystemExit)
      end
    end
    context "when a team's monpoke is defeated and it doesn't do ICHOOSE you next turn" do
      let!(:input) {
        ["CREATE Rocket Meekachu 3 1",
         "CREATE Rocket Rastly 5 6",
         "CREATE Green Smorelax 2 1",
         "ICHOOSEYOU Meekachu",
         "ICHOOSEYOU Smorelax",
         "ATTACK",
         "ATTACK",
         "ATTACK", #this is the invalid move
         "ATTACK",
         "ATTACK"]
      }
      it "it raises error" do
        expect { subject.play(input) }.to raise_error(SystemExit)
      end
    end
  end
end
