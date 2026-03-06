import { Component } from '@angular/core';
import { TranslateModule } from '@ngx-translate/core';
import { HomeNewsComponent as BaseComponent } from '../../../../../app/home-page/home-news/home-news.component';
import { ThemedConfigurationSearchPageComponent } from '../../../../../app/search-page/themed-configuration-search-page.component';
import { ThemedHomeNewsComponent } from '../../../../../app/home-page/home-news/themed-home-news.component';
import { ThemedSearchFormComponent } from '../../../../../app/shared/search-form/themed-search-form.component';

@Component({
  selector: 'ds-themed-home-news',
  // styleUrls: ['./home-news.component.scss'],
  styleUrls: [
      '../../../../../app/home-page/home-news/home-news.component.scss',
      './home-news.component.scss'
  ],
  templateUrl: './home-news.component.html',
  // templateUrl: '../../../../../app/home-page/home-news/home-news.component.html',
  standalone: true,
    imports: [
        ThemedConfigurationSearchPageComponent,
        ThemedHomeNewsComponent,
        ThemedSearchFormComponent,
        TranslateModule,
    ],
})
export class HomeNewsComponent extends BaseComponent {
}
