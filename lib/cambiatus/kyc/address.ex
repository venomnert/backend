defmodule Cambiatus.Kyc.Address do
  @moduledoc """
  Address Ecto Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Cambiatus.{
    Accounts.User,
    Repo,
    Kyc.Country,
    Kyc.State,
    Kyc.City,
    Kyc.Neighborhood
  }

  schema "addresses" do
    field(:street, :string)
    field(:zip, :string)
    field(:number, :string)

    belongs_to(:country, Country)
    belongs_to(:state, State)
    belongs_to(:city, City)
    belongs_to(:neighborhood, Neighborhood)
    belongs_to(:account, User, references: :account, type: :string)

    timestamps()
  end

  @required_fields ~w(account_id country_id street neighborhood_id city_id state_id zip)a
  @optional_fields ~w(number)a

  def changeset(model, params \\ :empty) do
    model
    |> Repo.preload(:country)
    |> cast(params, @required_fields ++ @optional_fields)
    |> foreign_key_constraint(:country_id)
    |> foreign_key_constraint(:state_id)
    |> foreign_key_constraint(:account_id)
    |> validate_country()
    |> validate_state()
    |> validate_city()
    |> validate_neighborhood()
    |> validate_zip()
  end

  def validate_zip(changeset) do
    if Enum.any?(costa_rica_zip_codes(), &(&1 == get_field(changeset, :zip))) do
      changeset
    else
      add_error(changeset, :zip, "Invalid Zip Code")
    end
  end

  def validate_country(changeset) do
    country_id = get_field(changeset, :country_id)

    case Repo.get(Country, country_id) do
      nil ->
        changeset
        |> add_error(:country_id, "Country not found")

      country ->
        if country.name == "Costa Rica" do
          changeset
        else
          add_error(changeset, :country_id, "We only support 'Costa Rica'")
        end
    end
  end

  def validate_state(changeset) do
    id = get_field(changeset, :state_id)

    with state when not is_nil(state) <- Repo.get(State, id),
         country when not is_nil(country) <- Repo.get(Country, get_field(changeset, :country_id)) do
      if Enum.any?(Repo.preload(country, :states).states, &(&1.id == id)) do
        changeset
      else
        add_error(changeset, :state_id, "don't belong to country")
      end
    else
      nil ->
        add_error(changeset, :state_id, "is invalid")
    end
  end

  def validate_city(changeset) do
    id = get_field(changeset, :city_id)

    with city when not is_nil(city) <- Repo.get(City, id),
         state when not is_nil(state) <- Repo.get(State, get_field(changeset, :state_id)) do
      if Enum.any?(Repo.preload(state, :cities).cities, &(&1.id == id)) do
        changeset
      else
        add_error(changeset, :city_id, "don't belong to state")
      end
    else
      nil ->
        add_error(changeset, :city_id, "is invalid")
    end
  end

  def validate_neighborhood(changeset) do
    id = get_field(changeset, :neighborhood_id)

    with neighborhood when not is_nil(neighborhood) <- Repo.get(Neighborhood, id),
         city when not is_nil(city) <- Repo.get(City, get_field(changeset, :city_id)) do
      if Enum.any?(
           Repo.preload(city, :neighborhoods).neighborhoods,
           &(&1.id == id)
         ) do
        changeset
      else
        add_error(changeset, :neighborhood_id, "don't belong to city")
      end
    else
      nil ->
        add_error(changeset, :neighborhood_id, "is invalid")
    end
  end

  def costa_rica_zip_codes() do
    [
      "10101",
      "10102",
      "10103",
      "10104",
      "10105",
      "10106",
      "10107",
      "10108",
      "10109",
      "10110",
      "10111",
      "10201",
      "10202",
      "10203",
      "10301",
      "10302",
      "10303",
      "10304",
      "10305",
      "10306",
      "10307",
      "10308",
      "10309",
      "10310",
      "10311",
      "10312",
      "10313",
      "10401",
      "10402",
      "10403",
      "10404",
      "10405",
      "10406",
      "10407",
      "10408",
      "10409",
      "10501",
      "10502",
      "10503",
      "10601",
      "10602",
      "10603",
      "10604",
      "10605",
      "10606",
      "10607",
      "10701",
      "10702",
      "10703",
      "10704",
      "10705",
      "10706",
      "10707",
      "10801",
      "10802",
      "10803",
      "10804",
      "10805",
      "10806",
      "10807",
      "10901",
      "10902",
      "10903",
      "10904",
      "10905",
      "10906",
      "11001",
      "11002",
      "11003",
      "11004",
      "11005",
      "11101",
      "11102",
      "11103",
      "11104",
      "11105",
      "11201",
      "11202",
      "11203",
      "11204",
      "11205",
      "11301",
      "11302",
      "11303",
      "11304",
      "11305",
      "11401",
      "11402",
      "11403",
      "11501",
      "11502",
      "11503",
      "11504",
      "11601",
      "11602",
      "11603",
      "11604",
      "11605",
      "11701",
      "11702",
      "11703",
      "11801",
      "11802",
      "11803",
      "11804",
      "11901",
      "11902",
      "11903",
      "11904",
      "11905",
      "11906",
      "11907",
      "11908",
      "11909",
      "11910",
      "11911",
      "11912",
      "12001",
      "12002",
      "12003",
      "12004",
      "12005",
      "12006",
      "20101",
      "20102",
      "20103",
      "20104",
      "20105",
      "20106",
      "20107",
      "20108",
      "20109",
      "20110",
      "20111",
      "20112",
      "20113",
      "20114",
      "20201",
      "20202",
      "20203",
      "20204",
      "20205",
      "20206",
      "20207",
      "20208",
      "20209",
      "20210",
      "20211",
      "20212",
      "20213",
      "20214",
      "20301",
      "20302",
      "20303",
      "20304",
      "20305",
      "20307",
      "20308",
      "20401",
      "20402",
      "20403",
      "20404",
      "20501",
      "20502",
      "20503",
      "20504",
      "20505",
      "20506",
      "20507",
      "20508",
      "20601",
      "20602",
      "20603",
      "20604",
      "20605",
      "20606",
      "20607",
      "20608",
      "20701",
      "20702",
      "20703",
      "20704",
      "20705",
      "20706",
      "20707",
      "20801",
      "20802",
      "20803",
      "20804",
      "20805",
      "20901",
      "20902",
      "20903",
      "20904",
      "20905",
      "21001",
      "21002",
      "21003",
      "21004",
      "21005",
      "21006",
      "21007",
      "21008",
      "21009",
      "21010",
      "21011",
      "21012",
      "21013",
      "21101",
      "21102",
      "21103",
      "21104",
      "21105",
      "21106",
      "21107",
      "21201",
      "21202",
      "21203",
      "21204",
      "21205",
      "21301",
      "21302",
      "21303",
      "21304",
      "21305",
      "21306",
      "21307",
      "21308",
      "21401",
      "21402",
      "21403",
      "21404",
      "21501",
      "21502",
      "21503",
      "21504",
      "21601",
      "21602",
      "21603",
      "30101",
      "30102",
      "30103",
      "30104",
      "30105",
      "30106",
      "30107",
      "30108",
      "30109",
      "30110",
      "30111",
      "30201",
      "30202",
      "30203",
      "30204",
      "30205",
      "30301",
      "30302",
      "30303",
      "30304",
      "30305",
      "30306",
      "30307",
      "30308",
      "30401",
      "30402",
      "30403",
      "30501",
      "30502",
      "30503",
      "30504",
      "30505",
      "30506",
      "30507",
      "30508",
      "30509",
      "30510",
      "30511",
      "30512",
      "30601",
      "30602",
      "30603",
      "30701",
      "30702",
      "30703",
      "30704",
      "30705",
      "30801",
      "30802",
      "30803",
      "30804",
      "40101",
      "40102",
      "40103",
      "40104",
      "40105",
      "40201",
      "40202",
      "40203",
      "40204",
      "40205",
      "40206",
      "40301",
      "40302",
      "40303",
      "40304",
      "40305",
      "40306",
      "40307",
      "40308",
      "40401",
      "40402",
      "40403",
      "40404",
      "40405",
      "40406",
      "40501",
      "40502",
      "40503",
      "40504",
      "40505",
      "40601",
      "40602",
      "40603",
      "40604",
      "40701",
      "40702",
      "40703",
      "40801",
      "40802",
      "40803",
      "40901",
      "40902",
      "41001",
      "41002",
      "41003",
      "41004",
      "41005",
      "50101",
      "50102",
      "50103",
      "50104",
      "50105",
      "50201",
      "50202",
      "50203",
      "50204",
      "50205",
      "50206",
      "50207",
      "50301",
      "50302",
      "50303",
      "50304",
      "50305",
      "50306",
      "50307",
      "50308",
      "50309",
      "50401",
      "50402",
      "50403",
      "50404",
      "50501",
      "50502",
      "50503",
      "50504",
      "50601",
      "50602",
      "50603",
      "50604",
      "50605",
      "50701",
      "50702",
      "50703",
      "50704",
      "50801",
      "50802",
      "50803",
      "50804",
      "50805",
      "50806",
      "50807",
      "50808",
      "50901",
      "50902",
      "50903",
      "50904",
      "50905",
      "50906",
      "51001",
      "51002",
      "51003",
      "51004",
      "51101",
      "51102",
      "51103",
      "51104",
      "51105",
      "60101",
      "60102",
      "60103",
      "60104",
      "60105",
      "60106",
      "60107",
      "60108",
      "60109",
      "60110",
      "60111",
      "60112",
      "60113",
      "60114",
      "60115",
      "60116",
      "60201",
      "60202",
      "60203",
      "60204",
      "60205",
      "60206",
      "60301",
      "60302",
      "60303",
      "60304",
      "60305",
      "60306",
      "60307",
      "60308",
      "60309",
      "60401",
      "60402",
      "60403",
      "60501",
      "60502",
      "60503",
      "60504",
      "60505",
      "60506",
      "60601",
      "60602",
      "60603",
      "60701",
      "60702",
      "60703",
      "60704",
      "60801",
      "60802",
      "60803",
      "60804",
      "60805",
      "60806",
      "60901",
      "61001",
      "61002",
      "61003",
      "61004",
      "61101",
      "61102",
      "70101",
      "70102",
      "70103",
      "70104",
      "70201",
      "70202",
      "70203",
      "70204",
      "70205",
      "70206",
      "70207",
      "70301",
      "70302",
      "70303",
      "70304",
      "70305",
      "70306",
      "70307",
      "70401",
      "70402",
      "70403",
      "70404",
      "70501",
      "70502",
      "70503",
      "70601",
      "70602",
      "70603",
      "70604",
      "70605"
    ]
  end
end
