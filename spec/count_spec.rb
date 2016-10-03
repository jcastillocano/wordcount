# frozen_string_literal: true
require 'spec_helper'
require 'json'
require 'wordcount'

describe 'WordCount App - Count' do
  let(:app) { WordCountApp::Counter.new }

  describe 'Already parsed arsed method' do
    it 'File has never been parsed' do
      expect(app.already_parsed('foo')).to be false
    end

    it 'File has been parsed before' do
      app.count 'foo', ''
      expect(app.already_parsed('foo')).to be true
    end
  end

  describe 'Status method' do
    it 'Return previous file result' do
      app.count 'bar', 'Text'
      expect(app.status('bar')).to include '{"total":1,"words":{"Text":1}}'
    end
    it 'File never parsed' do
      expect(app.status('job')).to include '{"error": "File job not found"}'
    end
  end

  describe 'Count method' do
    it 'Parse valid text with no filter' do
      result = app.count 'jac1.txt', 'Bang bong % word bong Bong'
      expect(result).to include '{"total":5,"words":{"Bang":1,"bong":2,"word":1,"Bong":1}}'
    end

    it 'Parse valid text with filter' do
      result = app.count 'jac2.txt', 'Bang bong % word bong Bong', 'ong'
      expect(result).to include '{"total":2,"words":{"Bang":1,"word":1}}'
    end

    it 'Parse valid text with camel-case filter' do
      result = app.count 'jac3.txt', 'Bang bong % word bong Bong', 'bo'
      expect(result).to include '{"total":3,"words":{"Bang":1,"word":1,"Bong":1}}'
    end

    it 'Ignore everything but chars' do
      result = app.count 'jac4.txt', ',Bang{ .bong/ % word 12bong *Bong|'
      expect(result).to include '{"total":5,"words":{"Bang":1,"bong":2,"word":1,"Bong":1}}'
    end

    it 'No alpha chars split words' do
      result = app.count 'jac5.txt', 'Supercali1fragi,listi}cexpial?idocious'
      expected = '{"total":5,"words":{"Supercali":1,"fragi":1,"listi":1,"cexpial":1,"idocious":1}}'
      expect(result).to include expected
    end
  end
end
