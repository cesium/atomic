defmodule Atomic.Repo.Seeds.Accounts do
  def run do
    case Atomic.Repo.all(Atomic.Accounts.User) do
      [] ->
        [
          "Chandler Bing",
          "Monica Geller",
          "Ross Geller",
          "Joey Tribbiani",
          "Rachel Green",
          "Phoebe Buffay"
        ]
        |> create_users(:admin)

        [
          "Aberforth Dumbledore",
          "Adrian Mole",
          "Albus Dumbledore",
          "Albus Sverus Potter",
          "Amycus Carrow",
          "Anne Frank",
          "Anne of Green Gables",
          "Argus Filch",
          "Asterix Obelix",
          "Calvin and Hobbes",
          "Charity Burbage",
          "Charlie Brown",
          "Corto Maltese",
          "Curious George",
          "Dudley Dursley",
          "Elphias Doge",
          "Ernie Macmillan",
          "Filius Fitwick",
          "Fleur Delacour",
          "Gabrielle Delacour",
          "George Weasley",
          "Geronimo Stilton",
          "Gilderoy Lockhart",
          "Greg Heffley",
          "Gregory Goyle",
          "Hannah Abott",
          "Harry Potter",
          "Heidi and Marco",
          "Helena Ravenclaw",
          "Hermione Ganger",
          "Horce Slughorn",
          "Huckleberry Finn",
          "Hungry Catterpilar",
          "James Potter",
          "Katie Bell",
          "King Babar",
          "Lilly Evans Potter",
          "Lily Luna Potter",
          "Little Prince",
          "Lucious Malfoy",
          "Lucky Luck",
          "Luna Lovegood",
          "Mafalda Quino",
          "Malala Malala",
          "Marry Cattermole",
          "Michael Corner",
          "Molly Weasley",
          "Nancy Drew",
          "Narcissa Malfoy",
          "Neville Longbottom",
          "Nymphadora Tonks",
          "Padington Bear",
          "Padma Patil",
          "Pansy Parkinson",
          "Peppa Pig",
          "Percy Weasley",
          "Peter Rabbit",
          "Petunia Evans Dursley",
          "Pippi Longstocking",
          "Pomona Sprout",
          "Reginald Cattermole",
          "Reginald Coner",
          "Remus Lupin",
          "Rita Skeeter",
          "Rubeus Hagrid",
          "Rufus Scrimgeour",
          "Rupert Bear",
          "Scooby Doo",
          "Serlock Holmes",
          "Snoopy Dog",
          "Stuart Little",
          "Ted Tonks",
          "Throwfinn Rowle",
          "Tintin Herge",
          "Tom Sawyer",
          "Vernon Dursley",
          "Viktor Krum",
          "Vincent Crabbe",
          "Winnie de Pooh"
        ]
        |> create_users(:student)

        [
          "Bo Peep",
          "Bugs Bunny",
          "Buzz Lightyear",
          "Captain Hook",
          "Clara Cluck",
          "Clarabelle Cow",
          "Cruella de Vil",
          "Daisy Duck",
          "Dewey Duck",
          "Doc Hudson",
          "Donald Duck",
          "Eddie Valiant",
          "Horace Horsecollar",
          "Huey Duck",
          "Jessica Rabbit",
          "Judge Doom",
          "Lightning McQueen",
          "Little John",
          "Louie Duck",
          "Maid Marian",
          "Max Goof",
          "Mickey Mouse",
          "Minnie Mouse",
          "Mortimer Mouse",
          "Peter Pan",
          "Potato Head",
          "Prince John",
          "Queen of Hearts",
          "Robin Hood",
          "Roger Rabbit",
          "Sally Carrera",
          "Scrooge McDuck",
          "Speedy Gonzalez",
          "Sheriff of Nottingham",
          "Snow White",
          "Tiger Lily",
          "Tinker Bell",
          "Tweedle Dee",
          "Tweedle Dum",
          "Wendy Darling",
          "White Rabbit"
        ]
        |> create_users(:staff)
      _ ->
        Mix.shell().error("Found users, aborting seeding users.")
    end
  end

  def create_users(characters, role) do
    for character <- characters do
      email = (character |> String.downcase() |> String.replace(~r/\s*/, "")) <> "@mail.pt"

      user = %{
        "email" => email,
        "password" => "password1234",
        "role" => role
      }

      case Atomic.Accounts.register_user(user) do
        {:error, changeset} ->
          Mix.shell().error(Kernel.inspect(changeset.errors))

        {:ok, _} -> :ok
      end
    end
  end
end

Atomic.Repo.Seeds.Accounts.run
