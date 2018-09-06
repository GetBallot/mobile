# Design Doc

[Ballot](http://www.getballot.com) aims to make voting easier. Information for federal, state and local elections tend to be scattered all over the place, and it can be overwhelming for voters.


## Goals

* Show upcoming election date
* Compile candidates on the ballot of a voter, as determined by their address
* Allow voter to save their selections of candidates
* Show polling location
* Remind user to vote


## Screens

| Main                                 | |
| :----------------------------------: |-|
| Sign up / Login in / Skip            | Only shown to logged out users |
| &#x2193;                             | |
| **Address Input**                    | |
| Enter voting address                 | Skip if logged in: use address from user object |
| &#x2193;                             | |
| **Voting profile**                   | |
| Address, voting divisions, polling station, contests | |
| &#x2193;                             | |
| **Contest**                          | |
| Candidates, with stars for favorites | |
| &#x2193;                             | |
| **Candidate**                        | |
| Name, party, bio etc                 | |

## Google Civic Information API

[Google Civic Information API](https://developers.google.com/civic-information/) will be our primary data source.

[`voterInfoQuery`](https://developers.google.com/civic-information/docs/v2/elections/voterInfoQuery) returns upcoming election information when queried with the registered voting address.

Try it via the [Voting Information Project](https://votinginfoproject.org/projects/vip-voting-information-tool/).

It is almost exactly what we want, except:

* Data is not available until 2 - 4 weeks prior to the election.
* Candidate information tends to be minimal. For most candidates, only name and party are returned, even though the API has fields for other information.

      {
        "name": string,
        "party": string,
        "candidateUrl": string,
        "phone": string,
        "photoUrl": string,
        "email": string,
        "orderOnBallot": long,
        "channels": [
          {
            "type": string,
            "id": string
          }
        ]
      }

Before [`voterInfoQuery`](https://developers.google.com/civic-information/docs/v2/elections/voterInfoQuery) has election data, we can use [`representativeInfoByAddress`](https://developers.google.com/civic-information/docs/v2/representatives/representativeInfoByAddress) to retrieve the voting divisions for an address.

Here is the response for the test address `1263 Pacific Ave. Kansas City, KS`:

    {
     "kind": "civicinfo#representativeInfoResponse",
     "normalizedInput": {
      "line1": "1263 Pacific Avenue",
      "city": "Kansas City",
      "state": "KS",
      "zip": "66102"
     },
     "divisions": {
      "ocd-division/country:us": {
       "name": "United States"
      },
      "ocd-division/country:us/state:ks": {
       "name": "Kansas"
      },
      "ocd-division/country:us/state:ks/cd:3": {
       "name": "Kansas's 3rd congressional district"
      },
      "ocd-division/country:us/state:ks/county:wyandotte": {
       "name": "Wyandotte County"
      },
      "ocd-division/country:us/state:ks/county:wyandotte/council_district:2": {
       "name": "Wyandotte County Commissioner District 2"
      },
      "ocd-division/country:us/state:ks/place:kansas_city": {
       "name": "Kansas City city"
      },
      "ocd-division/country:us/state:ks/sldl:32": {
       "name": "Kansas State House district 32"
      },
      "ocd-division/country:us/state:ks/sldu:6": {
       "name": "Kansas State Senate district 6"
      }
     }
    }


## Supplementary Data

To have richer information earlier in the election cycle, we would compile contests and candidates for each voting division.

For each candidate, we would like to have:

* Name
* Party
* Short bio
* 5 photos
* Url
* Phone
* Email
* Social channels (e.g. Facebook, Twitter, Instagram)
* Endorsements (e.g. from NRA, Planned Parenthood)

## Firebase

We will be using Firebase as the datastore, with the following collections (the collection name are made into fake links so they have a different color):

### Candidates and Referendums
* [divisions]()/ocd-division,country:us,state:ca/[elections]()/20180605/[contests]()/Governor/[candidates]()/JohnChiangCA
* [divisions]()/ocd-division,country:us,state:ca/[elections]()/20180605/[contests]()/Prop70/[responses]()/Yes

Since Firebase does not allow slashes as key, `/` is replaced by `,` i.e.
`ocd-division/country:us/state:ca` becomes `ocd-division,country:us,state:ca`


#### Fields for contest

    {
      "office": string,
      "description": string
    }

Description is useful for offices like "Clerk and Recorder" where the name may not mean much on its own. We can also use it to provide party splits for offices like state senator.

#### Fields for candidate

    {
      "name": string,
      "party": string,
      "bio": string,
      "candidateUrl": string,
      "phone": string,
      "photos": [ string ],
      "email": string,
      "channels": [
        {
          "type": string,
          "id": string
        }
      ],
      "endorsements": [ string ]
    }

#### Fields for referendum

    {
      "title": string,
      "subtitle": string,
      "text": string
    }

### Users

* [users]()/qwertyuiop

The user id is generated by [Firebase auth](https://firebase.google.com/docs/auth/).

Collections/documents for user:
* `triggers/address`
* `elections/upcoming`
* `favs`  

The key for favorites is the full path for each candidate and referendum e.g. `divisions/ocd-division,country:us,state:ca/elections/20180605/contests/Governor/candidates/JohnChiangCA`

The key for each division is the OCD division identifier from [`representativeInfoByAddress`](https://developers.google.com/civic-information/docs/v2/representatives/representativeInfoByAddress) e.g. `ocd-division,country:us,state:ca`

Each division contains data for the first election in the future. The date is stored in the field `election` e.g. `20180605`

Example key for contest: `LtGovernor`. The value is the display name e.g. `Lieutenant Governor`

Together, `division`, `election` and` contest` makes the full key to retrieve the collection of that contest. e.g. [divisions]()/ocd-division,country:us,state:ca/[elections]()/20180605/[contests]()/LtGovernor/

When the user enters their address, if [`voterInfoQuery`](https://developers.google.com/civic-information/docs/v2/elections/voterInfoQuery) did not return any election data, we fetch `divisions` from [`representativeInfoByAddress`](https://developers.google.com/civic-information/docs/v2/representatives/representativeInfoByAddress) and write that to the user object. A cloud function will be triggered to fill in the contests.

### Elections

* [elections]()/4456

The key is the election id as returned by [`voterInfoQuery`](https://developers.google.com/civic-information/docs/v2/elections/voterInfoQuery).

#### Fields for election

    {
      "name": string,
      "electionDay": string,
      "ocdDivisionId": string,
      "divisionContest": {
       (key): canonical name
      },
      "contests": {
       (key): {
        "name": display name
        "candidates": {
         (key): canonical name       
        }
       }
      },
      "referendums": {
       (key): {
        "name": display name
        "responses": {
         (key): canonical name       
        }
       }       
      }
    }

This is used to generate Firebase keys for candidates and referendums from  [`voterInfoQuery`](https://developers.google.com/civic-information/docs/v2/elections/voterInfoQuery). Examples:

| Type       | From                        | To                                     |
| ---------- | ----------------------------| -------------------------------------- |
| divisionContest | administrativeArea2+Lieutenant Governor | ocd-division,country:us,state:ca+LtGovernor |
| divisionContest | 18th Congressional District+18th Congressional |  ocd-division,country:us,state:ca,cd:18+cd:18 |
| candidate  | JOHN CHIANG                 | JohnChiangCA                           |
| referendum | Proposition 70              | Prop70                                 |
| response   | YES                         | Yes                                    |

The division-contest pair mapping yields the key into the contests map.

:question: Is `+` a good divider for Firebase keys? See issue [#1](https://github.com/GetBallot/mobile/issues/1).

We use the twitter handle for the candidate as canonical name when possible.

## Data Entry

Create Google spreadsheets for volunteers to enter data, and [ingest](https://github.com/GetBallot/ingest) them into Firebase. 
