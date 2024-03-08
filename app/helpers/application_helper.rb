module ApplicationHelper
	class EncryptDecrypt
		def encrypt(urlparam)
			encrypted_string= Base64.encode64(Base64.encode64(Base64.encode64(urlparam)))
			return  encrypted_string
       	end

		def decrypt(urlparam)
			decrypted_string= Base64.decode64(Base64.decode64(Base64.decode64(urlparam))) rescue nil
			return  decrypted_string
       	end
	end
	
	def current_year
		Time.now.year
	end
end
