Paperclip::Attachment.default_options.update({
	# :url=>"/system/:class/:attachment/:id_partition/:style/:filename"
	:escape_url=>"true",
	:url=>"/system/:class/:attachment/:style/:subdir/:fingerprint.:fixed_extension"
	})

Paperclip.interpolates :subdir do |attachment, style|
	attachment.fingerprint[0..2]
end

Paperclip.interpolates :fixed_extension do |attachment, style|
	"jpg"
end
