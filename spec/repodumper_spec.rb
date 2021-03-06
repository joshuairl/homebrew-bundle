require "spec_helper"

describe Bundle::RepoDumper do
  context "when brew is not installed" do
    it "raises an error" do
      allow(Bundle).to receive(:brew_installed?).and_return(false)
      expect { Bundle::RepoDumper.new }.to raise_error
    end
  end

  context "when there is no tap" do
    before do
      allow(Bundle).to receive(:brew_installed?).and_return(true)
      allow_any_instance_of(Bundle::RepoDumper).to receive(:`).and_return("[]")
    end
    subject { Bundle::RepoDumper.new }

    it "returns empty list" do
      expect(subject.repos).to be_empty
    end

    it "dumps as empty string" do
      expect(subject.to_s).to eql("")
    end
  end

  context "there are tap `homebrew/foo` and `bitbucket/bar`" do
    before do
      allow(Bundle).to receive(:brew_installed?).and_return(true)
      allow_any_instance_of(Bundle::RepoDumper).to receive(:`)
      allow(JSON).to receive(:load).and_return [
        {
          "name" => "homebrew/foo",
          "remote" => "https://github.com/Homebrew/homebrew-foo",
          "custom_remote" => false,
        },
        {
          "name" => "bitbucket/bar",
          "remote" => "https://bitbucket.org/bitbucket/bar.git",
          "custom_remote" => true,
        },
      ]
    end
    subject { Bundle::RepoDumper.new }

    it "returns list of information" do
      expect(subject.repos).not_to be_empty
    end

    it "dumps output" do
      expect(subject.to_s).to eql("tap 'homebrew/foo'\ntap 'bitbucket/bar', 'https://bitbucket.org/bitbucket/bar.git'")
    end
  end
end
