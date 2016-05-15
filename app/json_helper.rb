#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

class JsonHelper
	@json_file
	attr_accessor :json
	attr_reader :sequence

	def initialize(json_file)
		@json_file = json_file
		@json = self.read(json_file)
	end

	# 解析json文件,如果不存在则自动创建
	def read(file)
		unless File.file?(file) then system("echo '{}'> #{file}") end

		return JSON.parse(File.read(file))
	end

	def flush
		File.open(@json_file, 'w') do |f|
			f.puts @json.to_json
		end
	end
	# 写入到config文件
	# field key
	# value 覆盖值
	def write_json(key, value)
    	file = File.dirname(__FILE__)+"/db/config"
		
    	json = parse_json_file("config")
    	@json[key] = value

    	File.open(file, 'w') do |f|
        	f.puts json.to_json
   	 	end

	end

	def sequence
		seq = @json["sequence"]
		@json["sequence"] = seq+1
		seq
	end
end
