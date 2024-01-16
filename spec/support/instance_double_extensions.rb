# Based on https://github.com/rspec/rspec-mocks/issues/794
module VerifiedDoubleExtensions
  def instance_double(klass, *args)
    super.tap do |dbl|
      allow(dbl).to receive(:is_a?) { false }
      allow(dbl).to receive(:is_a?).with(klass) { true }
    end
  end
end

RSpec.configure do |c|
  c.include VerifiedDoubleExtensions
end
