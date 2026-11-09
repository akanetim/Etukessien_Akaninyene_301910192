// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("account_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("account_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "transfer_requested",
                    "transfer_posted"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "transfer"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "transfer_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("account_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_requested",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "transfer_id": 301
            },
            "snapshot": {
                "transfer_id": 301,
                "account_id": 201,
                "amount": 125.75,
                "request_key": "req-001",
                "status": "posted",
                "occurred_at": "2025-05-01T10:15:00Z"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "account_id": 201
                    },
                    "via": [
                        "transfer.account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_posted",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "transfer_id": 301
            },
            "snapshot": {
                "transfer_id": 301,
                "account_id": 201,
                "amount": 125.75,
                "request_key": "req-001",
                "status": "posted",
                "occurred_at": "2025-05-01T10:15:00Z"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "account_id": 201
                    },
                    "via": [
                        "transfer.account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "risk_signals": "illustrative risk_signals",
                "channel_metadata": "illustrative channel_metadata"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_requested",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "transfer_id": 302
            },
            "snapshot": {
                "transfer_id": 302,
                "account_id": 202,
                "amount": 20,
                "request_key": "req-002",
                "status": "pending",
                "occurred_at": "2025-05-02T11:30:00+00:00"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "account_id": 202
                    },
                    "via": [
                        "transfer.account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_posted",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "transfer_id": 302
            },
            "snapshot": {
                "transfer_id": 302,
                "account_id": 202,
                "amount": 20,
                "request_key": "req-002",
                "status": "pending",
                "occurred_at": "2025-05-02T11:30:00+00:00"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "account_id": 202
                    },
                    "via": [
                        "transfer.account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "risk_signals": "illustrative risk_signals",
                "channel_metadata": "illustrative channel_metadata"
            }
        }
    }
]));
  await db.getCollection("account_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("account_events").find({"eventType":"transfer_requested"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("account_events").find({"source.key.transfer_id":301}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("account_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("account_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("account_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "transfer_requested",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "transfer",
        "key": {
            "transfer_id": 301
        },
        "snapshot": {
            "transfer_id": 301,
            "account_id": 201,
            "amount": 125.75,
            "request_key": "req-001",
            "status": "posted",
            "occurred_at": "2025-05-01T10:15:00Z"
        }
    },
    "embedded": {},
    "references": {
        "account": [
            {
                "key": {
                    "account_id": 201
                },
                "via": [
                    "transfer.account_id → account"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("account_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "transfer_requested",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "transfer",
        "key": {
            "transfer_id": 301
        },
        "snapshot": {
            "transfer_id": 301,
            "account_id": 201,
            "amount": 125.75,
            "request_key": "req-001",
            "status": "posted",
            "occurred_at": "2025-05-01T10:15:00Z"
        }
    },
    "embedded": {},
    "references": {
        "account": [
            {
                "key": {
                    "account_id": 201
                },
                "via": [
                    "transfer.account_id → account"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("account_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
