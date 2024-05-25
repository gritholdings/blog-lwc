import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import selectSearchResults from '@salesforce/apex/PublicArticleController.selectSearchResults';
import { sendVirtualPageView } from 'c/utilities';


export default class PublicSearch extends NavigationMixin(LightningElement) {
    isLoading = true;
    noResultsFound = false;
    searchQuery;
    @track searchResults = [];
    connectedCallback() {
        // get url query string value
        this.searchQuery = new URLSearchParams(window.location.search).get('q');
        const pageTitle = `${this.searchQuery} - Search`;
        sendVirtualPageView(pageTitle);
        selectSearchResults({ searchQuery: this.searchQuery })
            .then(data => {
                this.isLoading = false;
                this.searchResults = data;
                if (this.searchResults.length === 0) {
                    this.noResultsFound = true;
                } else {
                    this.noResultsFound = false;
                }
            })
            .catch(error => { console.log(error); });
    }

    onSearchKeydown(e) {
        if (e.keyCode == 13) {
            let searchQuery = e.target.value;
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: `/searchnow?q=${encodeURIComponent(searchQuery)}`
                }
            });
        }
    }
}