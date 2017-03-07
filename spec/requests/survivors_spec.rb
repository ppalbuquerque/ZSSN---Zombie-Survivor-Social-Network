require 'rails_helper'

RSpec.describe 'Survivors API', type: :request do
  # Initialize test data
  let!(:survivors){ create_list(:survivor, 10) }
  let(:id){ survivors.first.id }

  # Test Suite for GET /survivor
  describe 'GET /survivors' do
    # Making the http request
    before { get '/survivors' }

    # Creating the context ok
    context 'When we do not have a infected survivor' do
      # When we can get the survivor json
      it 'returns survivors (List Method)' do
          expect(json).not_to be_empty
      end

      # Testing the response code
      it 'return status code 200 (List Method)' do
        expect(response).to have_http_status(200)
      end
    end

    # Creating the context that we have a infected
    context 'When we have a infected survivor' do

      it 'Infect someone and should not return nothing' do
        # Reporting three times a survivor
        put '/survivors/report_infection', params:{id: 1}
        put '/survivors/report_infection', params:{id: 1}
        put '/survivors/report_infection', params:{id:  1}

        # Getting the list of survivor
        get '/survivors'
        # Testing the json response
        json.each do |js|
          expect(js['id']).not_to eq(1)
        end
      end
    end
  end

  # Test Suite for GET /survivor/:id
  describe 'GET /survivors/:id' do
    # Making the http request
    before { get "/survivors/#{id}"}
    # Creating the test context that expects no infected survivor
    context 'When we do not have a infected survivor' do
      #When we can get the desire survivor
      it 'returns survivor (Show Method)' do
        expect(json['id']).to eq(id)
      end

      # Testing the response code
      it 'Expecting code status 200' do
        expect(response).to have_http_status(200)
      end
    end

    # Creating the context that we have a infected one
    context "When we have a infected one" do
      it 'infect someone and try to return him' do
        # Reporting three times a survivor
        put '/survivors/report_infection', params:{id: 2}
        put '/survivors/report_infection', params:{id: 2}
        put '/survivors/report_infection', params:{id:  2}
        # Getting info from the survivor
        get '/survivors/2'
        expect(json['message']).to eq('The survivor is infected')
      end
      # Testing the response status code
      it 'getting someone infected to test the response code to be equal 404' do
        # Reporting three times a survivor
        put '/survivors/report_infection', params:{id: 2}
        put '/survivors/report_infection', params:{id: 2}
        put '/survivors/report_infection', params:{id:  2}
        # Getting info from the survivor
        get '/survivors/2'
        expect(response).to have_http_status(403)
      end
    end
  end

  # Test Suite for POST /survivors
  describe 'POST /survivors' do
    # Creating a valid payload
    let(:valid_payload) { { name: 'Link' , age: '15', gender: 'Male', last_x: '18.457', last_y: '25.345'} }

    # Creating the context for a valid request
    context 'when the request is valid' do
      # Making the http post request
      before { post '/survivors', params: valid_payload }

      # Succefuly creates a survivor
      it 'creates a survivor (Create Method)' do
        expect(json['name']).to eq('Link')
        expect(json['age']).to eq(15)
        expect(json['gender']).to eq('Male')
        expect(json['last_x']).to eq(18.457)
        expect(json['last_y']).to eq(25.345)
      end

      # Testing the response code for the post request
      it 'returns status code 201 (Create Method)' do
        expect(response).to have_http_status(201)
      end
    end

    context 'When the request is not valid' do
      it "Tries to create a survivor and put report_infected to 3"  do
        post '/survivors', params: { name: 'Link' , age: '15', gender: 'Male', last_x: '18.457', last_y: '25.345', report_infected: '3'}
        get '/survivors/11'
        expect(json['report_infected']).to eq(0)
      end
    end
  end

  # Test Suite for PUT /survivors/update_location
  describe 'PUT /survivors/update_location' do
    # Creating a valid payload
    let(:valid_payload) { {id: '3', last_x: '10.548', last_y: '15.385'} }

    # Creating the context for a valid request
    context 'when the request is valid' do
      # Making the http put request
      before { put '/survivors/update_location', params: valid_payload}

      # Succefuly update the location
      it 'updates the last survivor location (Update_Location Method)' do
        expect(response.body).to be_empty
      end

      # Testing the response code for the put request
      it 'Returns status code 204 (Update_Location Method)' do
        expect(response).to have_http_status(204)
      end
    end
    # Creating the context that will have a infected one
    context "When we try to update some infected location" do
      it 'Infect somoene and try do updtate his locations' do
        # Reporting three times a survivor
        put '/survivors/report_infection', params:{id: 2}
        put '/survivors/report_infection', params:{id: 2}
        put '/survivors/report_infection', params:{id:  2}
        # Updating the location
        put '/survivors/update_location', params:{id: 2, last_x: 10, last_y: 15}

        expect(json['message']).to eq('The survivor is infected')
      end
    end
  end

  # Test Suite for PUT /survivors/report_infection
  describe 'PUT /survivors/report_infection' do
    # Creating a valid payload
    let(:valid_payload) { {id: '3'} }

    # Creating the context for a valid request
    context 'When some survivor report another' do
      # Making the http put request
      before { put '/survivors/report_infection', params: valid_payload}

      # Succefuly report a infection
      it 'The survivor was reported Succefuly' do
        expect(json['report_infected']).to eq(1)
      end

      # Testing the status code
      it "The response code should be 202" do
        expect(response).to have_http_status(202)
      end
    end
  end

  # Test Suite for PUT /survivors/trade
  describe 'PUT /survivors/report_infection' do
    # Creating the context for a valid request
    context 'Both survivors are ok' do

      it 'Creates items and trade with healthly survivrs and do a equivalent trade' do
        post '/items', params: {name: 'Water', points: 4}
        post '/items', params: {name: 'Food', points: 3}
        post '/items', params: {name: 'Medication', points: 2}
        post '/items', params: {name: 'Ammunition', points: 1}
        post '/survivors', params:{
          name: 'link',
          age: 15,
          gender: 'male',
          last_x: 14.2,
          last_y: 15,
          items: [
              {id: 1, quant: 2},
              {id: 3, quant: 3}
          ]
        }
       post '/survivors', params:{
         name: 'sheik',
         age: 20,
         gender: 'male',
         last_x: 14.2,
         last_y: 15,
         items: [
             {id: 2, quant: 2},
             {id: 4, quant: 6}
         ]
       }
       put '/survivors/trade', params:{
         items_1: [
           {s_id: 11, it_id: 1, quant: 1},
           {s_id: 11, it_id: 3, quant: 1}
         ],
         items_2: [
           {s_id: 12, it_id: 2, quant: 2}
         ]
       }
       get '/survivors/12/inventory'
       expect(json['Food']).to eq(2)
     end

    it 'Creates items but now the trade is not equivalent, we wait a message' do
      post '/items', params: {name: 'Water', points: 4}
      post '/items', params: {name: 'Food', points: 3}
      post '/items', params: {name: 'Medication', points: 2}
      post '/items', params: {name: 'Ammunition', points: 1}
      post '/survivors', params:{
        name: 'link',
        age: 15,
        gender: 'male',
        last_x: 14.2,
        last_y: 15,
        items: [
            {id: 1, quant: 2},
            {id: 3, quant: 3}
        ]
      }
     post '/survivors', params:{
       name: 'sheik',
       age: 20,
       gender: 'male',
       last_x: 14.2,
       last_y: 15,
       items: [
           {id: 2, quant: 2},
           {id: 4, quant: 6}
       ]
     }
     put '/survivors/trade', params:{
       items_1: [
         {s_id: 11, it_id: 1, quant: 1},
       ],
       items_2: [
         {s_id: 12, it_id: 2, quant: 2}
       ]
     }
     expect(json['message']).to eq("The trade is not equivalent")
    end
    end

    context "When one of the survivors are infected" do
      it 'Creates items and survivors, report one of them and them wait for the infected message' do
        post '/items', params: {name: 'Water', points: 4}
        post '/items', params: {name: 'Food', points: 3}
        post '/items', params: {name: 'Medication', points: 2}
        post '/items', params: {name: 'Ammunition', points: 1}
        post '/survivors', params:{
          name: 'link',
          age: 15,
          gender: 'male',
          last_x: 14.2,
          last_y: 15,
          items: [
              {id: 1, quant: 2},
              {id: 3, quant: 3}
          ]
        }
       post '/survivors', params:{
         name: 'sheik',
         age: 20,
         gender: 'male',
         last_x: 14.2,
         last_y: 15,
         items: [
             {id: 2, quant: 2},
             {id: 4, quant: 6}
         ]
       }
       put '/survivors/report_infection', params: {id: 11}
       put '/survivors/report_infection', params: {id: 11}
       put '/survivors/report_infection', params: {id: 11}
       put '/survivors/trade', params:{
         items_1: [
           {s_id: 11, it_id: 1, quant: 1},
           {s_id: 11, it_id: 3, quant: 1}
         ],
         items_2: [
           {s_id: 12, it_id: 2, quant: 2}
         ]
       }
       expect(json['message']).to eq('The survivor is infected')
     end
    end
  end

  # Test Suite foir GET /survivros/:id/inventory
  describe 'GET /survivros/:id/inventory' do
    it 'Create some survivors with items and retrieve them, and wait for the right json' do
      post '/items', params: {name: 'Water', points: 4}
      post '/items', params: {name: 'Food', points: 3}
      post '/items', params: {name: 'Medication', points: 2}
      post '/items', params: {name: 'Ammunition', points: 1}
      post '/survivors', params:{
        name: 'link',
        age: 15,
        gender: 'male',
        last_x: 14.2,
        last_y: 15,
        items: [
            {id: 1, quant: 2},
            {id: 3, quant: 3}
        ]
      }
     post '/survivors', params:{
       name: 'sheik',
       age: 20,
       gender: 'male',
       last_x: 14.2,
       last_y: 15,
       items: [
           {id: 2, quant: 2},
           {id: 4, quant: 6}
       ]
     }
     get '/survivors/11/inventory'
     expect(json['Water']).to eq(2)
    end
    it 'Create some survivors, report as infected and with items and retrieve them, and wait for the right json' do
      post '/items', params: {name: 'Water', points: 4}
      post '/items', params: {name: 'Food', points: 3}
      post '/items', params: {name: 'Medication', points: 2}
      post '/items', params: {name: 'Ammunition', points: 1}
      post '/survivors', params:{
        name: 'link',
        age: 15,
        gender: 'male',
        last_x: 14.2,
        last_y: 15,
        items: [
            {id: 1, quant: 2},
            {id: 3, quant: 3}
        ]
      }
     post '/survivors', params:{
       name: 'sheik',
       age: 20,
       gender: 'male',
       last_x: 14.2,
       last_y: 15,
       items: [
           {id: 2, quant: 2},
           {id: 4, quant: 6}
       ]
     }
     put '/survivors/report_infection', params: {id: 11}
     put '/survivors/report_infection', params: {id: 11}
     put '/survivors/report_infection', params: {id: 11}
     get '/survivors/11/inventory'
     expect(json['message']).to eq('The survivor is infected')
  end
end
end
