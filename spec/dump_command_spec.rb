require "spec_helper"

describe Bundle::Commands::Dump do
  context "when files existed" do
    before do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
      allow(ARGV).to receive(:force?).and_return(false)
      allow(ARGV).to receive(:value).and_return(nil)
    end

    it "raises error" do
      expect do
        Bundler.with_clean_env { Bundle::Commands::Dump.run }
      end.to raise_error
    end
  end

  context "when files existed and `--force` is passed" do
    before do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
      allow(ARGV).to receive(:force?).and_return(true)
      allow(ARGV).to receive(:value).and_return(nil)
    end

    it "doesn't raise error" do
      io = double("File", :write => true)
      expect_any_instance_of(Pathname).to receive(:open).with("w") { |&block| block.call io }
      expect(io).to receive(:write)
      expect do
        Bundler.with_clean_env { Bundle::Commands::Dump.run }
      end.to_not raise_error
    end
  end
end
