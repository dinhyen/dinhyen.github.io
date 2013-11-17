#!/usr/bin/env ruby
require 'rubygems'
require 'thor'
require 'yaml'

class FileTools < Thor
  desc 'nodash', 'Replace dash from file names'
  def nodash
    files = Dir.entries(".")
    files.each do |f|
      if f =~ /--/
        new_f = f.gsub /\-\-/, ''
        system "mv -- #{f} #{new_f}"
      end
    end
  end

  desc 'to_markdown', 'Replace .html markdown extension with .markdown'
  # option :silent, :aliases => :s, :type => :boolean, :default => false, :desc => 'Write run time info to console'
  def to_markdown
    files = Dir.glob('**/*.html')
    files.each do |f|
      new_f = f.gsub 'html', 'markdown'
      system "mv #{f} #{new_f}" if File.file? f
    end
  end
end

FileTools.start