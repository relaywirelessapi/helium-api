# typed: false

RSpec.describe Relay::Solana::Idl::InstructionDefinition do
  describe "#deserialize" do
    it "deserializes the arguments and accounts" do
      data = [
        <<~EOF.delete("\n")
          8495a0e84fa7c2f810000000f0a80200be0e424fafbca0c51c7034ea2000000048656c69756d204d
          6f62696c6520537562736372696265722023373930313132012800000068747470733a2f2f736f6c
          2e68656c6c6f68656c69756d2e636f6d2f6170692f6d65746164617461
        EOF
      ].pack("H*")

      idl = Relay::Solana::Idl::ProgramDefinition.from_file(Rails.root.join("data/idls/mobile-entity-manager.json"))
      instruction = idl.find_instruction_from_data!(data)

      expect {
        instruction.deserialize(
          data,
          [
            "8LWKE6EiFBRsBSeHsZHqgCFaq3qxh9o1VpD6htK6mJV5",
            "3e8JftKoDz1GHyuPgGqq2T6Rw7njpqzjDrBRkSucQxJB",
            "HN1xNjSVAQwZjg6KYvk2FNoNE1FQxMrqyZTj8ixKp8e7",
            "8LWKE6EiFBRsBSeHsZHqgCFaq3qxh9o1VpD6htK6mJV5",
            "5S4n56zJZdqBQ5aNP6wJmqHBsHzWTnj1mvhL9N55zBgV",
            "8D7jbQJqebcuJMkxdiKS5Yk2is3et5anWDtZxpxvQgjS",
            "HPn9kaQ8Man6kKA9wu8jmWxsMMTrJVgf5RYJSozweSgF",
            "Fv5hf1Fg58htfC7YEXKNEfkpuogUUQDDTLgjGWxxv48H",
            "BQ3MCuTT5zVBhNfQ4SjMh3NPVhFy73MPV8rjfq5d1zie",
            "Gm9xDCJawDEKDrrQW6haw94gABaYzQwCq4ZQU8h8bd22",
            "DVKdkY89jJqQ28xMs2Nh8PLpBtbGwPEtKQo112Dv3mg",
            "7y4NCUyyiYdELNWv35VYwsa4r9Mzg8zSoxqnc5wKngLp",
            "8LWKE6EiFBRsBSeHsZHqgCFaq3qxh9o1VpD6htK6mJV5",
            "9YgvHbCTrRCvBd6ZEMsMAFBmk2SkWkySdYPK98y34F9S",
            "4ewWZC5gT6TGpm5LZNDs9wVonfUT2q5PP5sc9kVbwMAK",
            "metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s",
            "noopb9bkMVfRPU8AsbpTUg8AQkHtKwMYZiFUjNRtMmV",
            "BGUMAp9Gq7iTEuizy4pqaxsTyUCBK68MDfK752saRPUY",
            "cmtDvXumGCrqC1Age74AVPhSRVXJMd8PJS91L8KbNCK",
            "11111111111111111111111111111111",
            "hemjuPXBpNvggtaUnN1MwT3wrdhttKEfosTcc2P9Pg8"
          ],
          program_definition: idl
        )
      }.not_to raise_error
    end
  end
end
