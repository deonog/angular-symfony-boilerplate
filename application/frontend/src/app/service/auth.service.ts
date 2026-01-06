import { Injectable, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable, tap } from 'rxjs';
import { Router } from '@angular/router';

export interface User {
  id: number;
  email: string;
  roles: string[];
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private http = inject(HttpClient);
  private router = inject(Router);
  
  // Using signals for reactive state
  isLoggedIn = signal<boolean>(false);
  currentUser = signal<User | null>(null);
  
  private apiUrl = '/api';
  
  // For compatibility with code that expects observables
  private userSubject = new BehaviorSubject<User | null>(null);
  user$ = this.userSubject.asObservable();
  
  constructor() {
    // Check for existing token on startup
    const token = localStorage.getItem('auth_token');
    if (token) {
      this.isLoggedIn.set(true);
      this.loadUserProfile();
    }
  }
  
  login(email: string, password: string): Observable<any> {
    return this.http.post<{token: string, user: User}>(`${this.apiUrl}/login`, { email, password })
      .pipe(
        tap(response => {
          localStorage.setItem('auth_token', response.token);
          this.isLoggedIn.set(true);
          this.currentUser.set(response.user);
          this.userSubject.next(response.user);
        })
      );
  }
  
  logout(): void {
    localStorage.removeItem('auth_token');
    this.isLoggedIn.set(false);
    this.currentUser.set(null);
    this.userSubject.next(null);
    this.router.navigate(['/login']);
  }
  
  getToken(): string | null {
    return localStorage.getItem('auth_token');
  }
  
  private loadUserProfile(): void {
    this.http.get<User>(`${this.apiUrl}/user/profile`).subscribe({
      next: (user) => {
        this.currentUser.set(user);
        this.userSubject.next(user);
      },
      error: () => {
        // If we can't get the profile, the token might be invalid
        this.logout();
      }
    });
  }
} 