
require "feature/cache"

describe Feature::Cache do
  context "default mode" do
    it "generally works" do
      klass = Class.new do
        Feature::Cache.load(self)

        def x
          cache[:x]
        end

        def x=(value)
          cache[:x] = value
        end
      end

      r = klass.new
      expect(r.x).to be_nil
      r.x = 10
      expect(r.x).to eq 10
      expect(r.send(:cache)).to eq({:x => 10})
      expect(r.inspect).to include "{:x=>10}"
    end
  end

  context "invisible mode" do
    it "generally works" do
      klass = Class.new do
        Feature::Cache.load(self, invisible: true)

        def x
          cache[:x]
        end

        def x=(value)
          cache[:x] = value
        end
      end

      r = klass.new
      expect(r.x).to be_nil
      r.x = 10
      expect(r.x).to eq 10
      expect(r.send(:cache)).to eq({:x => 10})
      expect(r.inspect).not_to include "{:x=>10}"
    end
  end
end
