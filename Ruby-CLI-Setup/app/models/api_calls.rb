class APICalls

    #Returns a random advice string
    def self.advice 

        url= "https://api.adviceslip.com/advice"

        response = RestClient.get(url, {accept: :json})
        body = response.body
        parsed = JSON.parse(body)
        parsed["slip"]["advice"]
            
    end

    #Returns a random catfact string
    def self.catfact

        url = "https://cat-fact.herokuapp.com/facts"
    
        response = RestClient.get(url, {accept: :json})
        body = response.body
        parsed = JSON.parse(body)
        catfacts = parsed.map{ |fact| fact["text"] }
        catfacts.sample
        
    end

end