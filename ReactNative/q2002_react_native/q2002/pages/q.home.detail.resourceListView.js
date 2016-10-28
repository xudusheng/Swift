/**
 * Created by zhengda on 16/10/28.
 */
import React, {Component, PropTypes} from 'react';

import {
    StyleSheet,
    View,
    Image,
    Text,
    TouchableOpacity,
} from 'react-native';

export default class QResourceListView extends Component {
    static defaultProps = {
        resourceList: [],
        onClickButton:()=>{},
    };
    static propTypes = {
        //object
        // headerTitle: headerTitle
        //sourceList: sourceList
        //footerTitle: footerTitle
        resourceList: PropTypes.array.isRequired,
        onClickButton:PropTypes.func,
    };

    render() {
        console.log(this.props.resourceList);
        return (
            <View style={styles.resourceListViewContainerStyle}>
                {this.createResourceListView()}
            </View>
        );
    }

//TODO:创建集数列表-->标题，集数，观看帮助
    createResourceListView() {
        var resourceListViews = [];

        for (var i = 0; i < this.props.resourceList.length; i++) {
            let resouceIndex = i;
            var oneResouce = this.props.resourceList[resouceIndex];

            resourceListViews.push(<View key={-(resouceIndex+1)} style={{height: 30}}/>);//头部添加30高度的空白部分


            let title = oneResouce.headerTitle;
            let sourceList = oneResouce.sourceList;
            let footerTitle = oneResouce.footerTitle;

            let oneResouceContainerView =
                <View key={resouceIndex + 1} style={styles.oneResouceContainerViewStyle}>

                    <View style={styles.headerViewStyle}>
                        <Text style={styles.headerTextStyle}>{title}</Text>
                    </View>

                    <View style={styles.buttonListViewStyle}>
                        {this.createButtonLise(sourceList)}
                    </View>

                    <View style={styles.footerViewStyle}>
                        <Text style={styles.footerTextStyle}>{footerTitle}</Text>
                    </View>
                </View>

            resourceListViews.push(oneResouceContainerView);
        }
        return resourceListViews;
    }

    createButtonLise(sourceList) {
        var buttonList = [];
        for (var i = sourceList.length-1; i >= 0; i--) {
            let buttonIndex = i;
            let oneSource = sourceList[buttonIndex];

            // title: btnTitle,
            // href: GlobleConst.FetchURL + href,
            let title = oneSource.title;
            let href = oneSource.href;

            let button =
                <TouchableOpacity key={buttonIndex} onPress={()=>this.props.onClickButton(href)} style={styles.buttonViewStyle}>
                        <Text style={styles.buttonTitleStyle}>{title}</Text>
                </TouchableOpacity>
            buttonList.push(button);
        }
        return buttonList;
    }

}


const styles = StyleSheet.create({
    resourceListViewContainerStyle: {
        backgroundColor: 'white',

    },
    oneResouceContainerViewStyle: {
        backgroundColor: '#eeeeee',
        borderTopWidth: 0.5,
        borderTopColor: '#bbbbbb',
        borderBottomWidth: 0.5,
        borderBottomColor: '#bbbbbb',
    },

    headerViewStyle: {},
    headerTextStyle: {},

    footerViewStyle: {},
    footerTextStyle: {},


    buttonListViewStyle: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        backgroundColor: 'white',
        borderTopWidth: 0.5,
        borderTopColor: '#bbbbbb',
        borderBottomWidth: 0.5,
        borderBottomColor: '#bbbbbb',
    },

    buttonViewStyle: {
        width: 60,
        height: 25,
        justifyContent: 'center',
        alignItems: 'center',
        margin: 5,
        backgroundColor: '#999999',
    },
    buttonTitleStyle: {},
});
