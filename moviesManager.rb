require 'optparse'
require 'fileutils'
require 'logger'

log = Logger.new(STDOUT)

log.info "Parsing script arguments"
options = {}
OptionParser.new do |opt|
	opt.on('--filmDir FILM DIRECTORY') { |o| options[:filmDir] = o }
end.parse!

if not File.exist?(options[:filmDir])
	log.error "The directory #{options[:filmDir]} doesn't exist"
	exit -1
end

if not /film$/.match(options[:filmDir].to_s)
	log.error "The directory is not called 'film'"
	exit -1
end

log.info "Script arguments : #{options}" 

tabPeriodes = Array.new 

# parsing directories
Dir.foreach(options[:filmDir]) do |file|
	log.debug "Parsing dir :#{options[:filmDir]}/#{file}"
	if res1=/^\d\d\d\d-\d\d\d\d$/.match(file)
		anneeMin = /^\d\d\d\d/.match(res1.to_s)
		anneeMax = /\d\d\d\d$/.match(res1.to_s)
		tabPeriodes.push([anneeMin.to_s,anneeMax.to_s])
	end
end

# Parsing files
Dir.foreach(options[:filmDir]) do |file|
	log.debug "Parsing file :#{options[:filmDir]}/#{file}"
	if res1=/\.\d\d\d\d\./.match(file)
		if res2=/\d\d\d\d/.match(res1.to_s)
			res2=res2.to_s.to_i
			tabPeriodes.each{|periode|
				if res2 >= periode[0].to_i and res2<= periode[1].to_i
				    FileUtils.mv "#{options[:filmDir]}/#{file}","#{options[:filmDir]}/#{periode[0]}-#{periode[1]}"
					log.info "-> The file #{options[:filmDir]}/#{file} is moved into the directory #{options[:filmDir]}/#{periode[0]}-#{periode[1]}"
				end
			}			 
		end
	end
end

log.info "End the script"





