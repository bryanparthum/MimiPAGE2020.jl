

m = page_model()
include("../src/components/RCPSSPScenario.jl")
include("../src/components/CH4emissions.jl")

scenario = add_comp!(m, RCPSSPScenario)
ch4emit = add_comp!(m, ch4emissions)

scenario[:ssp] = "rcp85"

ch4emit[:er_CH4emissionsgrowth] = scenario[:er_CH4emissionsgrowth]
set_param!(m, :ch4emissions, :e0_baselineCH4emissions, readpagedata(m, "data/e0_baselineCH4emissions.csv")) #PAGE 2009 documentation pp38
set_param!(m, :ch4emissions, :er_CH4emissionsgrowth, readpagedata(m, "data/er_CH4emissionsgrowth.csv"))

##running Model
run(m)

# Generated data
emissions= m[:ch4emissions,  :e_regionalCH4emissions]

# Recorded data
emissions_compare=readpagedata(m, "test/validationdata/e_regionalCH4emissions.csv")

@test emissions ≈ emissions_compare rtol=1e-3
