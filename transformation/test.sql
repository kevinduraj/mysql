INSERT INTO engine82.part_0bc
          SELECT DISTINCT (sha256url)
              ,md5root
              ,url
              ,root
              ,tags
              ,title
              ,body
              ,alexa
              ,rank
              ,hit1
              ,hit2
              ,hit3
              ,category
              ,period
              ,gunning
              ,flesch
              ,kincaid
              ,sentence
              ,words
              ,syllables
              ,complex
            FROM engine81.part_0bc;


