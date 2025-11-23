import { LightningElement, wire, track } from 'lwc';
import getSubscribers from '@salesforce/apex/SubscriberController.getSubscribers';
import getSubscriberCount from '@salesforce/apex/SubscriberController.getSubscriberCount';

const COLUMNS = [
    { label: 'Subscriber Name', fieldName: 'Name', type: 'text' },
    { label: 'Country', fieldName: 'Country__c', type: 'text' },
    { label: 'Created By', fieldName: 'CreatedByName', type: 'text' },
    { label: 'Data Used', fieldName: 'Data_Used__c', type: 'number' },
    { label: 'Date Joined', fieldName: 'Date_Joined__c', type: 'date' },
    { label: 'Email', fieldName: 'Email__c', type: 'email' },
    { label: 'Last Modified By', fieldName: 'LastModifiedByName', type: 'text' },
    { label: 'Phone', fieldName: 'Phone__c', type: 'phone' },
    { label: 'Status', fieldName: 'Status__c', type: 'text' }
];

export default class SubscriberList extends LightningElement {
    @track subscribers = [];
    @track currentPage = 1;
    @track totalPages = 1;
    @track searchTerm = '';
    @track includeDisconnected = false;
    pageSize = 10;
    columns = COLUMNS;

    @wire(getSubscribers, { searchTerm: '$searchTerm', includeDisconnected: '$includeDisconnected', pageNumber: '$currentPage', pageSize: '$pageSize' })
    wiredSubscribers({ error, data }) {
        if (data) {
            this.subscribers = data.map(record => ({
                ...record,
                CreatedByName: record.CreatedBy ? record.CreatedBy.Name : '',
                LastModifiedByName: record.LastModifiedBy ? record.LastModifiedBy.Name : ''
            }));
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getSubscriberCount, { searchTerm: '$searchTerm', includeDisconnected: '$includeDisconnected' })
    wiredCount({ error, data }) {
        if (data) {
            this.totalPages = Math.ceil(data / this.pageSize);
        } else if (error) {
            console.error(error);
        }
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        this.currentPage = 1;
    }

    handleIncludeDisconnectedChange(event) {
        this.includeDisconnected = event.target.checked;
        this.currentPage = 1;
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
        }
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
        }
    }

    get isPreviousDisabled() {
        return this.currentPage === 1;
    }

    get isNextDisabled() {
        return this.currentPage === this.totalPages;
    }
}