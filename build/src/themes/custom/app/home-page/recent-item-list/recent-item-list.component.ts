import { Component } from '@angular/core';
import { RecentItemListComponent as BaseComponent } from '../../../../../app/home-page/recent-item-list/recent-item-list.component';

@Component({
    selector: 'ds-recent-item-list',
    templateUrl: './recent-item-list.component.html',
    styleUrls: ['./recent-item-list.component.scss'],
    changeDetection: ChangeDetectionStrategy.OnPush,
    animations: [
        fadeIn,
        fadeInOut
    ]
})
export class RecentItemListComponent extends BaseComponent {

}
