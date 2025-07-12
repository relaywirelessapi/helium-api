# typed: false

RSpec.describe Relay::Solana::InstructionDeserializer do
  describe "#deserialize" do
    it "deserializes an instruction" do
      idl = Relay::Solana::Idl::ProgramDefinition.from_file(Rails.root.join("data/idls/mobile-entity-manager.json"))

      deserializer = described_class.new(idl)
      result = deserializer.deserialize(
        [ "8495a0e84fa7c2f810000000f0a80200be0e424fafbca0c51c7034ea2000000048656c69756d204d6f62696c6520537562736372696265722023373930313132012800000068747470733a2f2f736f6c2e68656c6c6f68656c69756d2e636f6d2f6170692f6d65746164617461" ].pack("H*"),
        account_addresses: [
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
        ]
      ).as_json

      expect(result).to eq(
        {
          "instruction_definition": {
            "name": "initialize_subscriber_v0",
            "discriminator": [
              132,
              149,
              160,
              232,
              79,
              167,
              194,
              248
            ],
            "accounts": [
              {
                "name": "payer",
                "writable": true,
                "signer": true,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": null
              },
              {
                "name": "program_approval",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "const",
                      "value": [
                        112,
                        114,
                        111,
                        103,
                        114,
                        97,
                        109,
                        95,
                        97,
                        112,
                        112,
                        114,
                        111,
                        118,
                        97,
                        108
                      ],
                      "path": null
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "dao"
                    },
                    {
                      "kind": "const",
                      "value": [
                        11,
                        112,
                        65,
                        158,
                        72,
                        168,
                        159,
                        152,
                        187,
                        188,
                        122,
                        42,
                        226,
                        37,
                        14,
                        7,
                        167,
                        195,
                        247,
                        53,
                        180,
                        5,
                        192,
                        31,
                        89,
                        114,
                        217,
                        86,
                        169,
                        50,
                        218,
                        93
                      ],
                      "path": null
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "helium_entity_manager_program"
                  }
                },
                "relations": [],
                "address": null
              },
              {
                "name": "carrier",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": null
              },
              {
                "name": "issuing_authority",
                "writable": false,
                "signer": true,
                "optional": false,
                "pda": null,
                "relations": [
                  "carrier"
                ],
                "address": null
              },
              {
                "name": "collection",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [
                  "carrier"
                ],
                "address": null
              },
              {
                "name": "collection_metadata",
                "writable": true,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "const",
                      "value": [
                        109,
                        101,
                        116,
                        97,
                        100,
                        97,
                        116,
                        97
                      ],
                      "path": null
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "token_metadata_program"
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "collection"
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "token_metadata_program"
                  }
                },
                "relations": [],
                "address": null
              },
              {
                "name": "collection_master_edition",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "const",
                      "value": [
                        109,
                        101,
                        116,
                        97,
                        100,
                        97,
                        116,
                        97
                      ],
                      "path": null
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "token_metadata_program"
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "collection"
                    },
                    {
                      "kind": "const",
                      "value": [
                        101,
                        100,
                        105,
                        116,
                        105,
                        111,
                        110
                      ],
                      "path": null
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "token_metadata_program"
                  }
                },
                "relations": [],
                "address": null
              },
              {
                "name": "entity_creator",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "const",
                      "value": [
                        101,
                        110,
                        116,
                        105,
                        116,
                        121,
                        95,
                        99,
                        114,
                        101,
                        97,
                        116,
                        111,
                        114
                      ],
                      "path": null
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "dao"
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "helium_entity_manager_program"
                  }
                },
                "relations": [],
                "address": null
              },
              {
                "name": "dao",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [
                  "sub_dao"
                ],
                "address": null
              },
              {
                "name": "sub_dao",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [
                  "carrier"
                ],
                "address": null
              },
              {
                "name": "key_to_asset",
                "writable": true,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": null
              },
              {
                "name": "tree_authority",
                "writable": true,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "account",
                      "value": null,
                      "path": "merkle_tree"
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "bubblegum_program"
                  }
                },
                "relations": [],
                "address": null
              },
              {
                "name": "recipient",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": null
              },
              {
                "name": "merkle_tree",
                "writable": true,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [
                  "carrier"
                ],
                "address": null
              },
              {
                "name": "bubblegum_signer",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "const",
                      "value": [
                        99,
                        111,
                        108,
                        108,
                        101,
                        99,
                        116,
                        105,
                        111,
                        110,
                        95,
                        99,
                        112,
                        105
                      ],
                      "path": null
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "bubblegum_program"
                  }
                },
                "relations": [],
                "address": null
              },
              {
                "name": "token_metadata_program",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s"
              },
              {
                "name": "log_wrapper",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "noopb9bkMVfRPU8AsbpTUg8AQkHtKwMYZiFUjNRtMmV"
              },
              {
                "name": "bubblegum_program",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "BGUMAp9Gq7iTEuizy4pqaxsTyUCBK68MDfK752saRPUY"
              },
              {
                "name": "compression_program",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "cmtDvXumGCrqC1Age74AVPhSRVXJMd8PJS91L8KbNCK"
              },
              {
                "name": "system_program",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "11111111111111111111111111111111"
              },
              {
                "name": "helium_entity_manager_program",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "hemjuPXBpNvggtaUnN1MwT3wrdhttKEfosTcc2P9Pg8"
              }
            ],
            "args": [
              {
                "name": "args",
                "type": {
                  "name": "InitializeSubscriberArgsV0"
                }
              }
            ]
          },
          "args": [
            {
              "arg_definition": {
                "name": "args",
                "type": {
                  "name": "InitializeSubscriberArgsV0"
                }
              },
              "value": {
                "entity_key": "8KgCAL4OQk+vvKDFHHA06g==",
                "name": "Helium Mobile Subscriber #790112",
                "metadata_url": "https://sol.hellohelium.com/api/metadata"
              }
            }
          ],
          "accounts": [
            {
              "account_definition": {
                "name": "payer",
                "writable": true,
                "signer": true,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": null
              },
              "address": "8LWKE6EiFBRsBSeHsZHqgCFaq3qxh9o1VpD6htK6mJV5"
            },
            {
              "account_definition": {
                "name": "program_approval",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "const",
                      "value": [
                        112,
                        114,
                        111,
                        103,
                        114,
                        97,
                        109,
                        95,
                        97,
                        112,
                        112,
                        114,
                        111,
                        118,
                        97,
                        108
                      ],
                      "path": null
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "dao"
                    },
                    {
                      "kind": "const",
                      "value": [
                        11,
                        112,
                        65,
                        158,
                        72,
                        168,
                        159,
                        152,
                        187,
                        188,
                        122,
                        42,
                        226,
                        37,
                        14,
                        7,
                        167,
                        195,
                        247,
                        53,
                        180,
                        5,
                        192,
                        31,
                        89,
                        114,
                        217,
                        86,
                        169,
                        50,
                        218,
                        93
                      ],
                      "path": null
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "helium_entity_manager_program"
                  }
                },
                "relations": [],
                "address": null
              },
              "address": "3e8JftKoDz1GHyuPgGqq2T6Rw7njpqzjDrBRkSucQxJB"
            },
            {
              "account_definition": {
                "name": "carrier",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": null
              },
              "address": "HN1xNjSVAQwZjg6KYvk2FNoNE1FQxMrqyZTj8ixKp8e7"
            },
            {
              "account_definition": {
                "name": "issuing_authority",
                "writable": false,
                "signer": true,
                "optional": false,
                "pda": null,
                "relations": [
                  "carrier"
                ],
                "address": null
              },
              "address": "8LWKE6EiFBRsBSeHsZHqgCFaq3qxh9o1VpD6htK6mJV5"
            },
            {
              "account_definition": {
                "name": "collection",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [
                  "carrier"
                ],
                "address": null
              },
              "address": "5S4n56zJZdqBQ5aNP6wJmqHBsHzWTnj1mvhL9N55zBgV"
            },
            {
              "account_definition": {
                "name": "collection_metadata",
                "writable": true,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "const",
                      "value": [
                        109,
                        101,
                        116,
                        97,
                        100,
                        97,
                        116,
                        97
                      ],
                      "path": null
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "token_metadata_program"
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "collection"
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "token_metadata_program"
                  }
                },
                "relations": [],
                "address": null
              },
              "address": "8D7jbQJqebcuJMkxdiKS5Yk2is3et5anWDtZxpxvQgjS"
            },
            {
              "account_definition": {
                "name": "collection_master_edition",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "const",
                      "value": [
                        109,
                        101,
                        116,
                        97,
                        100,
                        97,
                        116,
                        97
                      ],
                      "path": null
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "token_metadata_program"
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "collection"
                    },
                    {
                      "kind": "const",
                      "value": [
                        101,
                        100,
                        105,
                        116,
                        105,
                        111,
                        110
                      ],
                      "path": null
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "token_metadata_program"
                  }
                },
                "relations": [],
                "address": null
              },
              "address": "HPn9kaQ8Man6kKA9wu8jmWxsMMTrJVgf5RYJSozweSgF"
            },
            {
              "account_definition": {
                "name": "entity_creator",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "const",
                      "value": [
                        101,
                        110,
                        116,
                        105,
                        116,
                        121,
                        95,
                        99,
                        114,
                        101,
                        97,
                        116,
                        111,
                        114
                      ],
                      "path": null
                    },
                    {
                      "kind": "account",
                      "value": null,
                      "path": "dao"
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "helium_entity_manager_program"
                  }
                },
                "relations": [],
                "address": null
              },
              "address": "Fv5hf1Fg58htfC7YEXKNEfkpuogUUQDDTLgjGWxxv48H"
            },
            {
              "account_definition": {
                "name": "dao",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [
                  "sub_dao"
                ],
                "address": null
              },
              "address": "BQ3MCuTT5zVBhNfQ4SjMh3NPVhFy73MPV8rjfq5d1zie"
            },
            {
              "account_definition": {
                "name": "sub_dao",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [
                  "carrier"
                ],
                "address": null
              },
              "address": "Gm9xDCJawDEKDrrQW6haw94gABaYzQwCq4ZQU8h8bd22"
            },
            {
              "account_definition": {
                "name": "key_to_asset",
                "writable": true,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": null
              },
              "address": "DVKdkY89jJqQ28xMs2Nh8PLpBtbGwPEtKQo112Dv3mg"
            },
            {
              "account_definition": {
                "name": "tree_authority",
                "writable": true,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "account",
                      "value": null,
                      "path": "merkle_tree"
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "bubblegum_program"
                  }
                },
                "relations": [],
                "address": null
              },
              "address": "7y4NCUyyiYdELNWv35VYwsa4r9Mzg8zSoxqnc5wKngLp"
            },
            {
              "account_definition": {
                "name": "recipient",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": null
              },
              "address": "8LWKE6EiFBRsBSeHsZHqgCFaq3qxh9o1VpD6htK6mJV5"
            },
            {
              "account_definition": {
                "name": "merkle_tree",
                "writable": true,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [
                  "carrier"
                ],
                "address": null
              },
              "address": "9YgvHbCTrRCvBd6ZEMsMAFBmk2SkWkySdYPK98y34F9S"
            },
            {
              "account_definition": {
                "name": "bubblegum_signer",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": {
                  "seeds": [
                    {
                      "kind": "const",
                      "value": [
                        99,
                        111,
                        108,
                        108,
                        101,
                        99,
                        116,
                        105,
                        111,
                        110,
                        95,
                        99,
                        112,
                        105
                      ],
                      "path": null
                    }
                  ],
                  "program": {
                    "kind": "account",
                    "value": null,
                    "path": "bubblegum_program"
                  }
                },
                "relations": [],
                "address": null
              },
              "address": "4ewWZC5gT6TGpm5LZNDs9wVonfUT2q5PP5sc9kVbwMAK"
            },
            {
              "account_definition": {
                "name": "token_metadata_program",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s"
              },
              "address": "metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s"
            },
            {
              "account_definition": {
                "name": "log_wrapper",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "noopb9bkMVfRPU8AsbpTUg8AQkHtKwMYZiFUjNRtMmV"
              },
              "address": "noopb9bkMVfRPU8AsbpTUg8AQkHtKwMYZiFUjNRtMmV"
            },
            {
              "account_definition": {
                "name": "bubblegum_program",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "BGUMAp9Gq7iTEuizy4pqaxsTyUCBK68MDfK752saRPUY"
              },
              "address": "BGUMAp9Gq7iTEuizy4pqaxsTyUCBK68MDfK752saRPUY"
            },
            {
              "account_definition": {
                "name": "compression_program",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "cmtDvXumGCrqC1Age74AVPhSRVXJMd8PJS91L8KbNCK"
              },
              "address": "cmtDvXumGCrqC1Age74AVPhSRVXJMd8PJS91L8KbNCK"
            },
            {
              "account_definition": {
                "name": "system_program",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "11111111111111111111111111111111"
              },
              "address": "11111111111111111111111111111111"
            },
            {
              "account_definition": {
                "name": "helium_entity_manager_program",
                "writable": false,
                "signer": false,
                "optional": false,
                "pda": null,
                "relations": [],
                "address": "hemjuPXBpNvggtaUnN1MwT3wrdhttKEfosTcc2P9Pg8"
              },
              "address": "hemjuPXBpNvggtaUnN1MwT3wrdhttKEfosTcc2P9Pg8"
            }
          ]
        }
      )
    end
  end
end
