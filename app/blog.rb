#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

class Blog
	def run (method)
		if (self.methods.include?(("_" + method).to_sym))
			eval("self._" + method)
		else
			puts 'no method defined'
		end
	end

	def _new
		json_helper = JsonHelper.new(DB_JSON)
		
		# 创建文章
		hash = self.new_post_hash(json_helper)

		realfilename = POSTS_DIR + hash["file"] 
		f = File.new(realfilename,  "w")
		json_helper.json["posts"].push hash

		json_helper.json["categories"] = Array.new
		json_helper.flush


		system("open #{realfilename}");
	end

	def new_post_hash(json_helper)
		hash = Hash.new
		id = json_helper.sequence
		hash["id"] = id
		hash["file"] = id.to_s + ".md"
		hash["title"] = id.to_s
		hash["md5"] = ""
		hash["history_files"] = Array.new
		return hash
	end
end
