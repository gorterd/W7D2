class User < ApplicationRecord
    
    attr_reader :password

    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 8}, allow_nil: true

    before_validation :ensure_session_token
    
    ####
        # insert associations here
    ###

    def self.find_by_credentials(email, pw)
        match = self.find_by(email: email)
        match.is_password?(pw) ? match : nil
    end

    def password=(pw)
        @password = pw
        self.password_digest = BCrypt::Password.create(pw)
    end

    def reset_session_token!
        self.session_token = generate_session_token
        self.save!

        self.session_token
    end

    def is_password?(pw)
        BCrypt::Password
            .new(self.password_digest)
            .is_password?(pw)
    end

    private

    def generate_session_token
        loop do
            token = SecureRandom::urlsafe_base64(32)
            return token unless self.class.exists?(session_token: token)
        end
    end

    def ensure_session_token
        self.session_token ||= generate_session_token
    end

end
