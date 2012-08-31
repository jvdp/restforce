require 'spec_helper'

describe Restforce::Middleware::Mashify do
  let(:app)        { double('app')            }
  let(:options)    { { } }
  let(:middleware) { described_class.new app, nil, options }

  before do
    app.should_receive(:call)
    middleware.call(env)
  end

  context 'when the body contains a records key' do
    let(:env) { { body: JSON.parse(fixture('sobject/query_success_response')) } }

    it 'converts the response body into a restforce collection' do
      env[:body].should be_a Restforce::Collection
    end
  end

  context 'when the body does not contain a records key' do
    let(:env) { { body: 'foobar' } }
    it 'does not touch the body' do
      env[:body].should eq 'foobar'
    end
  end
end
