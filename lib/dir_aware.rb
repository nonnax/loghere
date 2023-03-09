#!/usr/bin/env ruby
# Id$ nonnax 2023-01-15 09:35:00
require 'file/filer'
require 'rubytools/ansi_color'
require 'optparse'
opts = {}

class DirAware
 def initialize(f='~/.notes/loghere.json'.to_pathname)
  @file, @db = Filer.load_json(f){ Hash.new() }
  File.backup!(f) if File.age(f) > 60*15
 end

 def key(other=nil)
  Dir.pwd.split('/').last(2).join('/')
 end

 def reset_keys
  @db.transform_keys!{|k| k.to_s.split('/').last(2).join('/')}
  @file.write @db
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

  @db
  .each_with_object([]){|pair, arr|
    k, v = pair
    # arr<<format("# %s\n\n%s\n\n", k, v&.map{|r| [Time.at(r.shift).to_s.yellow] + r }.join("\n"))
    arr<<format("# %s\n\n%s\n\n", k, v&.join("\n"))
  }
  .join("\n")
  .then(&method(:puts))
 end

 def to_s
  # return "" unless @db[key]
  @db.keys
  .select{|k| [k.start_with?(key), k.start_with?(key.split('/').last)].any? }
  .map{ |key| show key }
  .reverse
  .join("\n\n")
 end

 def show key
    @db[key]
    &.map{|r| r }
    &.then{|arr| arr.prepend(key.to_s.blue) }
    &.join("\n")
 end
end

