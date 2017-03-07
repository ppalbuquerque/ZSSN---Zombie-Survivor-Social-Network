require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  # Initialize test data
  let!(:items){ create_list(:item, 10) }
  let(:item){ items.first.id }

  # Test Suite for GET /items
  describe 'GET /items' do
    # Making the http request
    before { get '/items' }

    # When we can get the items json
    it 'returns items (List Method)' do
        expect(json).not_to be_empty
    end

    # Testing the response code
    it 'return status code 200 (List Method)' do
      expect(response).to have_http_status(200)
    end
  end

  # Test Suite foir POST /items
  describe 'POST /items' do
    # Creating a valid payload
    let(:valid_payload) { { name: 'Water' , points: '4'} }

    # Creating the context for a valid request
    context 'when the request is valid' do
      # Making the http post request
      before { post '/items', params: valid_payload }

      # Succefuly creates a item
      it 'creates a item (Create Method)' do
        expect(json['name']).to eq('Water')
        expect(json['points']).to eq(4)
      end

      # Testing the response code for the post request
      it 'returns status code 201 (Create Method)' do
        expect(response).to have_http_status(201)
      end
    end
  end

end
