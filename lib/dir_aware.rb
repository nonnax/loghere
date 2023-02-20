#!/usr/bin/env ruby
# Id$ nonnax 2023-01-15 09:35:00
require 'file/filer'
require 'rubytools/ansi_color'
require 'optparse'
opts = {}

class DirAware
 def initialize(f='~/.notes/loghere.json'.to_pathname)
  @stategy = JSONFile.new(f)
  @file, @db = Filer.load(@stategy){ Hash.new() }
  File.backup!(f) if File.age(f) > 60*15
 end

 def key(other=nil)
  Dir.pwd
 end

 def push(v)
  (@db[key] ||= []) << v
 end

 def save(&block)
  text = block.call
  return if text.strip.empty?

  push [Time.now.to_i, text]
  @file.write @db
  self
 rescue => e
  puts e.backtrace
 end

 def dump
  headers=@db.keys
  f=format 'loghere_dump-%d.md', Time.now.to_i

  text=
  @db
  .each_with_object([]){|pair, arr|
    k, v = pair
    arr<<format("# %s\n\n%s\n\n", k, v&.map{|r| [Time.at(r.shift).to_s.yellow] + r }.join("\n"))
  }
  .join("\n")
  .then(&method(:puts))
 end

 def to_s
  return "" unless @db[key]
  @db.dup[key].map{|r| [Time.at(r.shift).to_s.blue] + r }.join("\n")
 end
end

