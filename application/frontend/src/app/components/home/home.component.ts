import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../service/api.service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './home.component.html'
})
export class HomeComponent implements OnInit {
  private apiService = inject(ApiService);
  
  welcomeMessage = 'Welcome to the Angular Symfony Boilerplate!';
  features: string[] = [
    'Angular 18+ with standalone components',
    'Symfony 7+ backend',
    'TypeScript support',
    'SASS styling',
    'Docker containerization'
  ];
  apiInfo: any;
  apiFeatures: string[] = [];
  loading = true;

  ngOnInit(): void {
    this.apiService.getInfo().subscribe({
      next: (info) => {
        this.apiInfo = info;
        this.loading = false;
      },
      error: (err) => {
        console.error('Failed to load API info', err);
        this.loading = false;
      }
    });

    this.apiService.getFeatures().subscribe({
      next: (data) => {
        this.apiFeatures = data.features;
      },
      error: (err) => {
        console.error('Failed to load API features', err);
      }
    });
  }
} 