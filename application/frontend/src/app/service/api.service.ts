import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private http = inject(HttpClient);
  private apiUrl = '/api';

  getInfo(): Observable<any> {
    return this.http.get(`${this.apiUrl}/info`);
  }

  getFeatures(): Observable<any> {
    return this.http.get(`${this.apiUrl}/features`);
  }
} 