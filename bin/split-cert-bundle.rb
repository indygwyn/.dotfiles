#!/usr/bin/env ruby

require "openssl"
require "pp"

if ARGV.length < 1
  puts "Usage: split-cert-bundle.rb ca-cert-bundle.pem"
  exit 1
end

if File.exist? ARGV[0]
  cert_delim = "\n-----END CERTIFICATE-----\n"
  IO.binread(ARGV[0]).split(cert_delim).each do |chunk|
    chunk.strip!
    chunk += cert_delim
    begin
      cert = OpenSSL::X509::Certificate.new chunk
    rescue
      puts "Skipping garbage"
      next
    end
    begin
      filename = sprintf("%x.0", cert.subject.hash)
      File.open(filename, File::WRONLY | File::CREAT | File::EXCL) do |f|
        subject = cert.subject
        expires = cert.not_after
        puts "Writing #{filename} #{expires} #{subject}"
        f.write(chunk)
      end
    rescue Errno::EEXIST
      puts "Skipping existing file #{filename}"
    end
  end
else
  puts "#{ARGV[0]} file does not exist"
  exit 1
end
